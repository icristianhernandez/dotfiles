# Just trying that.
{
  config,
  const,
  pkgs,
  guardRole,
  ...
}:

let
  piSettings = builtins.toJSON {
    defaultThinkingLevel = "medium";
    theme = "dark";
    quietStartup = true;
  };

  piSystemPrompt = ''
    You are Pi, running inside Neovim terminal.
    Be concise, technical, and explicit about file paths.
    Prefer minimal diffs.
    Before risky shell actions, explain risk and safer alternative.
    If blocked by policy, propose least-privilege command.
  '';

  piApprovalGate = ''
    import type { ExtensionAPI, ExtensionContext, ToolCallEvent } from "@mariozechner/pi-coding-agent";

    type Decision = "allow" | "ask" | "deny";

    type ToolRule = {
      defaultDecision: Decision;
      allow?: string[];
      deny?: string[];
      allowPaths?: string[];
      denyPaths?: string[];
    };

    const policy: { defaultDecision: Decision; tools: Record<string, ToolRule> } = {
      defaultDecision: "ask",
      tools: {
        bash: {
          defaultDecision: "ask",
          allow: [
            "true",
            "pwd",
            "ls",
            "ls *",
            "git status",
            "git status *",
            "git diff",
            "git diff *",
            "rg",
            "rg *",
            "nix run ./nixos#ci"
          ],
          deny: [
            "*git push*",
            "*git commit*",
            "*sudo *",
            "*rm -rf*",
            "*mkfs*",
            "*dd if=* of=/dev/*"
          ]
        },
        read: {
          defaultDecision: "allow",
          denyPaths: ["*.env", "*.env.*", "**/.env", "**/.env.*", "**/secrets/**"]
        },
        grep: {
          defaultDecision: "allow",
          denyPaths: ["*.env", "*.env.*", "**/.env", "**/.env.*", "**/secrets/**"]
        },
        edit: {
          defaultDecision: "ask",
          allowPaths: ["**/*.nix", "**/*.lua", "**/*.md", "**/*.json", "**/*.ts", "**/*.tsx"],
          denyPaths: ["*.env", "*.env.*", "**/.env", "**/.env.*", "**/secrets/**", "**/.git/**", "**/node_modules/**"]
        },
        write: {
          defaultDecision: "ask",
          allowPaths: ["**/*.nix", "**/*.lua", "**/*.md", "**/*.json", "**/*.ts", "**/*.tsx"],
          denyPaths: ["*.env", "*.env.*", "**/.env", "**/.env.*", "**/secrets/**", "**/.git/**", "**/node_modules/**"]
        }
      }
    };

    const escapeRegex = (value: string): string => value.replace(/[.*+?^''${}()|[\]\\]/g, "\\$&");
    const wildcardToRegex = (pattern: string): RegExp =>
      new RegExp("^" + pattern.split("*").map(escapeRegex).join(".*") + "$");

    const matchAny = (value: string, patterns?: string[]): boolean => {
      if (!patterns || patterns.length === 0) return false;
      return patterns.some((pattern) => wildcardToRegex(pattern).test(value));
    };

    const normalizePath = (path: string): string => path.replaceAll("\\\\", "/");

    const getToolPath = (event: ToolCallEvent): string | undefined => {
      const input = event.input as Record<string, unknown>;
      const value = input.path;
      return typeof value === "string" ? normalizePath(value) : undefined;
    };

    const getToolCommand = (event: ToolCallEvent): string | undefined => {
      if (event.toolName !== "bash") return undefined;
      const input = event.input as Record<string, unknown>;
      const value = input.command;
      return typeof value === "string" ? value.trim() : undefined;
    };

    const previewFor = (event: ToolCallEvent): string => {
      const command = getToolCommand(event);
      if (command) return command;
      const path = getToolPath(event);
      if (path) return path;
      return JSON.stringify(event.input);
    };

    const decide = (event: ToolCallEvent): { decision: Decision; reason: string } => {
      const rule = policy.tools[event.toolName] ?? { defaultDecision: policy.defaultDecision };

      const command = getToolCommand(event);
      if (command) {
        if (matchAny(command, rule.deny)) return { decision: "deny", reason: "bash deny pattern matched" };
        if (matchAny(command, rule.allow)) return { decision: "allow", reason: "bash allow pattern matched" };
        return { decision: rule.defaultDecision, reason: "bash default decision" };
      }

      const path = getToolPath(event);
      if (path) {
        if (matchAny(path, rule.denyPaths)) return { decision: "deny", reason: "path deny pattern matched" };
        if (matchAny(path, rule.allowPaths)) return { decision: "allow", reason: "path allow pattern matched" };
        return { decision: rule.defaultDecision, reason: "path default decision" };
      }

      return { decision: rule.defaultDecision, reason: "tool default decision" };
    };

    export default function (pi: ExtensionAPI) {
      let lastTheme: "dark" | "light" | undefined;

      const desktopNotify = async (title: string, body: string): Promise<void> => {
        try {
          await pi.exec("notify-send", ["-a", "pi", "-u", "normal", title, body], { timeout: 1500 });
        } catch {
          // no-op
        }
      };

      const detectTheme = async (): Promise<"dark" | "light" | undefined> => {
        try {
          const darkman = await pi.exec("darkman", ["get"], { timeout: 1200 });
          if (darkman.code === 0) {
            const value = darkman.stdout.trim().toLowerCase();
            if (value.includes("dark")) return "dark";
            if (value.includes("light")) return "light";
          }
        } catch {
          // fall through
        }

        try {
          const gs = await pi.exec(
            "gsettings",
            ["get", "org.gnome.desktop.interface", "color-scheme"],
            { timeout: 1200 }
          );
          if (gs.code === 0) {
            const value = gs.stdout.toLowerCase();
            return value.includes("dark") ? "dark" : "light";
          }
        } catch {
          // fall through
        }

        return undefined;
      };

      const syncTheme = async (ctx: ExtensionContext): Promise<void> => {
        if (!ctx.hasUI) return;
        const next = await detectTheme();
        if (!next || next === lastTheme) return;
        ctx.ui.setTheme(next);
        lastTheme = next;
      };

      pi.on("session_start", async (_event, ctx) => {
        await syncTheme(ctx);
      });

      pi.on("input", async (_event, ctx) => {
        await syncTheme(ctx);
        return { action: "continue" };
      });

      pi.on("tool_call", async (event, ctx) => {
        const decision = decide(event);

        if (decision.decision === "allow") return undefined;
        if (decision.decision === "deny") {
          return { block: true, reason: "Denied by policy: " + decision.reason };
        }

        const preview = previewFor(event).slice(0, 220);
        await desktopNotify("Pi approval needed", event.toolName + ": " + preview);

        if (!ctx.hasUI) {
          return { block: true, reason: "Approval required but no UI available" };
        }

        const ok = await ctx.ui.confirm(
          "Pi approval required",
          "Tool: " + event.toolName + "\\nInput: " + preview + "\\n\\nAllow this one time?"
        );

        if (!ok) {
          return { block: true, reason: "Blocked by user" };
        }

        return undefined;
      });
    }
  '';
in

guardRole "dev" {
  home.packages = with pkgs; [
    pkgs.unstable.pi-coding-agent
    pkgs.libnotify
    pkgs.glib
  ];

  home.file.".pi/agent/settings.json".text = piSettings;
  home.file.".pi/agent/SYSTEM.md".text = piSystemPrompt;
  home.file.".pi/agent/extensions/approval-gate.ts".text = piApprovalGate;
}
