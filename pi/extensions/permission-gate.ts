/**
 * Permission Gate Extension
 *
 * General permission system for external directories, bash commands, and
 * file operations. Has NO default permissions — modes inject permissions
 * via pi.events ("mode:changed"). Intercepts all tool_call events and
 * enforces mode-specific allowlists.
 */

import type { ExtensionAPI, ExtensionContext, ToolCallEvent } from "@mariozechner/pi-coding-agent";

interface Permissions {
  allowedTools: string[];
  bashAllowlist: RegExp[];
  bashBlocklist: RegExp[];
  externalDirsAllowed: boolean;
  externalDirsAllowlist: string[];
  protectedPaths: string[];
  promptOnExternalWrite: boolean;
  promptOnBash: boolean;
}

const PLAN_PERMISSIONS: Permissions = {
  allowedTools: ["read", "bash", "grep", "find", "ls", "questionnaire"],
  bashAllowlist: [
    /^\s*(nix\s+(run\s+\.\/nixos#ci|eval|search|flake)\b)/i,
    /^\s*git\s+(status|diff|log|show|branch|ls-)/i,
    /^\s*rg\b/,
    /^\s*ls\b/,
    /^\s*curl\b/,
    /^\s*wget\b/,
    /^\s*(cat|head|tail|less|more|grep|find|pwd|echo|wc|sort|uniq|file|stat|du|df|tree|which|whereis|type|env|printenv|uname|whoami|id|date|uptime|ps|jq|fd|eza|bat|sed\s+-n|awk)\b/,
    /^\s*npm\s+(list|ls|view|info|search|outdated|audit)/i,
    /^\s*yarn\s+(list|info|why|audit)/i,
    /^\s*(node|python|go|rustc|cargo)\s+--version/i,
    /^\s*mermaid-cli\b/,
    /^\s*mmdc\b/,
    /^\s*statix\b/,
    /^\s*sqlfluff\b/,
    /^\s*supabase\b/,
  ],
  bashBlocklist: [
    /\brm\b/,
    /\bmv\b/,
    /\bcp\b/,
    /\bmkdir\b/,
    /\btouch\b/,
    /\bchmod\b/,
    /\bchown\b/,
    /\bchgrp\b/,
    /\bdd\b/,
    /\bshred\b/,
    /\btruncate\b/,
    /\bnpm\s+(install|uninstall|update|ci|link|publish|add|remove)/i,
    /\byarn\s+(add|remove|install|publish)/i,
    /\bpnpm\s+(add|remove|install|publish)/i,
    /\bpip\s+(install|uninstall)/i,
    /\bapt(-get)?\s+(install|remove|purge|update|upgrade)/i,
    /\bbrew\s+(install|uninstall|upgrade)/i,
    /\bgit\s+(push|commit|add|merge|rebase|reset|checkout|stash|cherry-pick|revert|tag|init|clone)/i,
    /\bsudo\b/,
    /\bsu\b/,
    /\bkill\b/,
    /\bpkill\b/,
    /\bkillall\b/,
    /\breboot\b/,
    /\bshutdown\b/,
    /\bsystemctl\s+(start|stop|restart|enable|disable)/i,
    /\bservice\s+\S+\s+(start|stop|restart)/i,
    /\b(vim?|nano|emacs|code|subl)\b/,
  ],
  externalDirsAllowed: false,
  externalDirsAllowlist: [],
  protectedPaths: [".env", ".git/", "node_modules/", ".direnv/", "result", "secrets/"],
  promptOnExternalWrite: true,
  promptOnBash: false,
};

const NORMAL_PERMISSIONS: Permissions = structuredClone(PLAN_PERMISSIONS);
NORMAL_PERMISSIONS.allowedTools.push("edit", "write");
NORMAL_PERMISSIONS.bashAllowlist.push(
  /^\s*npm\s+(install|uninstall|ci|run|test|lint|build|dev|start|publish)/i,
  /^\s*yarn\s+(add|remove|install|run|build|dev|start)/i,
  /^\s*pnpm\s+(add|remove|install|run|build|dev|start)/i,
  /^\s*git\s+(add|commit|push|pull|merge|rebase|reset|checkout|branch|stash|cherry-pick|revert)/i,
  /^\s*mkdir\b/,
  /^\s*touch\b/,
  /^\s*cp\b/,
  /^\s*mv\b/,
  /^\s*nix\s+(build|develop|shell|run|flake|store|copy|hash|registry|profile)/i,
  /^\s*cargo\b/,
  /^\s*go\b/,
  /^\s*gnumake\b/,
  /^\s*make\b/,
  /^\s*python\b/,
  /^\s*python3\b/,
  /^\s*(pip|pip3)\s+(install|uninstall)/i,
);
NORMAL_PERMISSIONS.bashBlocklist = [
  /\brm\s+(-rf?|--recursive)/i,
  /\bsudo\b.*\brm\b/i,
  /\b(chmod|chown)\b.*777/i,
  /\bdd\b.*if=.*of=/i,
  /\bshred\b/,
  /\breboot\b/,
  /\bshutdown\b/,
  /\bgit\s+push\s+.*(--force|--delete|-f)/i,
  /\bkill\s+-9\b/,
];
NORMAL_PERMISSIONS.externalDirsAllowed = true;
NORMAL_PERMISSIONS.promptOnBash = false;
NORMAL_PERMISSIONS.promptOnExternalWrite = true;

function resolvePermissions(mode: string): Permissions {
  if (mode === "plan") return structuredClone(PLAN_PERMISSIONS);
  if (mode === "normal") {
    const merged = structuredClone(PLAN_PERMISSIONS);
    merged.allowedTools = [...new Set([...merged.allowedTools, ...NORMAL_PERMISSIONS.allowedTools])];
    merged.bashAllowlist = [...merged.bashAllowlist, ...NORMAL_PERMISSIONS.bashAllowlist];
    merged.bashBlocklist = NORMAL_PERMISSIONS.bashBlocklist;
    merged.externalDirsAllowed = NORMAL_PERMISSIONS.externalDirsAllowed;
    merged.externalDirsAllowlist = NORMAL_PERMISSIONS.externalDirsAllowlist;
    merged.promptOnExternalWrite = NORMAL_PERMISSIONS.promptOnExternalWrite;
    merged.promptOnBash = NORMAL_PERMISSIONS.promptOnBash;
    return merged;
  }
  return structuredClone(PLAN_PERMISSIONS);
}

function isExternalPath(targetPath: string, cwd: string): boolean {
  if (!targetPath) return false;
  const resolved = targetPath.startsWith("/") ? targetPath : `${cwd}/${targetPath}`;
  return !resolved.startsWith(cwd);
}

function isProtectedPath(targetPath: string, protectedPaths: string[]): boolean {
  return protectedPaths.some((p) => targetPath.includes(p));
}

export default function (pi: ExtensionAPI): void {
  let currentMode = "normal";
  let perms = resolvePermissions(currentMode);

  pi.events.on("mode:changed", (data) => {
    const { mode } = data as { mode: string };
    if (mode === "plan" || mode === "normal") {
      currentMode = mode;
      perms = resolvePermissions(mode);
    }
  });

  pi.on("tool_call", async (event, ctx) => {
    const toolEvent = event as ToolCallEvent;
    const toolName = toolEvent.toolName;

    if (!perms.allowedTools.includes(toolName)) {
      if (ctx.hasUI) {
        ctx.ui.notify(`Tool "${toolName}" is not available in ${currentMode} mode.`, "warning");
      }
      return {
        block: true,
        reason: `Tool "${toolName}" is not available in ${currentMode} mode.`,
      };
    }

    if (toolName === "bash") {
      const command = toolEvent.input.command as string;
      if (!command) return undefined;

      const isBlocked = perms.bashBlocklist.some((p) => p.test(command));
      if (isBlocked) {
        if (ctx.hasUI) {
          const choice = await ctx.ui.select(
            `Blocked command in ${currentMode} mode:\n\n  ${command}\n\nAllow anyway?`,
            ["Yes", "No"],
          );
          if (choice === "Yes") return undefined;
        }
        return {
          block: true,
          reason: `Command blocked in ${currentMode} mode: ${command}`,
        };
      }

      const isAllowed = perms.bashAllowlist.some((p) => p.test(command));
      if (!isAllowed) {
        if (ctx.hasUI) {
          pi.events.emit("permission:required", {
            toolName: "bash",
            reason: `Unlisted command: ${command}`,
          });
          const choice = await ctx.ui.select(
            `Command not in ${currentMode} allowlist:\n\n  ${command}\n\nAllow?`,
            ["Yes", "No"],
          );
          if (choice === "Yes") return undefined;
        }
        return {
          block: true,
          reason: `Command not in ${currentMode} allowlist: ${command}`,
        };
      }
    }

    if (toolName === "write" || toolName === "edit") {
      const targetPath = (toolEvent.input.path || toolEvent.input.file_path) as string;

      if (isProtectedPath(targetPath, perms.protectedPaths)) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Blocked ${toolName} to protected path: ${targetPath}`, "warning");
        }
        return {
          block: true,
          reason: `Path "${targetPath}" is protected.`,
        };
      }

      if (!perms.externalDirsAllowed && isExternalPath(targetPath, ctx.cwd)) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Blocked ${toolName} to external path: ${targetPath}`, "warning");
        }
        return {
          block: true,
          reason: `External directory access blocked in ${currentMode} mode: ${targetPath}`,
        };
      }

      if (perms.promptOnExternalWrite && isExternalPath(targetPath, ctx.cwd)) {
        if (ctx.hasUI) {
          pi.events.emit("permission:required", {
            toolName,
            reason: `Writing outside project: ${targetPath}`,
          });
          const choice = await ctx.ui.select(
            `Writing outside project directory:\n\n  ${targetPath}\n\nAllow?`,
            ["Yes", "No"],
          );
          if (choice !== "Yes") {
            return { block: true, reason: "External write denied by user." };
          }
        } else {
          return { block: true, reason: "External write blocked (no UI for confirmation)." };
        }
      }
    }

    return undefined;
  });
}
