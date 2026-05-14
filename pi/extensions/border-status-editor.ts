/**
 * Border Status Editor Extension
 *
 * Replaces the default editor with a CustomEditor subclass that
 * decorates the top/bottom border lines with live status info:
 * spinner, model name, thinking level, context usage, cwd, git branch.
 */

import { CustomEditor, type ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { Theme } from "@mariozechner/pi-coding-agent";

class BorderStatusEditor extends CustomEditor {
  private getStatusLine(theme: Theme): string {
    const model = this.context?.model?.id || "?";
    const thinking = this.pi?.getThinkingLevel?.() || "?";
    const cwd = this.context?.cwd?.split("/").pop() || "";

    const parts: string[] = [];
    parts.push(theme.fg("dim", `[${model}]`));
    parts.push(theme.fg("dim", `think:${thinking}`));

    if (cwd) {
      parts.push(theme.fg("muted", cwd));
    }

    return parts.join(" ");
  }

  render(width: number): string[] {
    const lines = super.render(width);
    const theme = this.theme;

    if (lines.length >= 2) {
      const status = this.getStatusLine(theme);
      const pad = Math.max(0, width - status.length);
      lines[0] = status + " ".repeat(pad);
    }

    return lines;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setEditorComponent((tui, theme, kb) => new BorderStatusEditor(tui, theme, kb));
  });
}
