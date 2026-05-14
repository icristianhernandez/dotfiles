/**
 * Rainbow Editor Extension
 *
 * Colorizes occurrences of "ultrathink" with a rainbow animated shine effect.
 * Cosmetic enhancement for the editor.
 */

import { CustomEditor, type ExtensionAPI } from "@mariozechner/pi-coding-agent";

const COLORS: [number, number, number][] = [
  [233, 137, 115],
  [228, 186, 103],
  [141, 192, 122],
  [102, 194, 179],
  [121, 157, 207],
  [157, 134, 195],
  [206, 130, 172],
];
const RESET = "\x1b[0m";

function brighten(rgb: [number, number, number], factor: number): string {
  const [r, g, b] = rgb.map((c) => Math.round(c + (255 - c) * factor));
  return `\x1b[38;2;${r};${g};${b}m`;
}

function colorize(text: string, shinePos: number): string {
  return [...text]
    .map((c, i) => {
      const baseColor = COLORS[i % COLORS.length]!;
      let factor = 0;
      if (shinePos >= 0) {
        const dist = Math.abs(i - shinePos);
        if (dist === 0) factor = 0.7;
        else if (dist === 1) factor = 0.35;
      }
      return `${brighten(baseColor, factor)}${c}`;
    })
    .join("") + RESET;
}

class RainbowEditor extends CustomEditor {
  private animationTimer?: ReturnType<typeof setInterval>;
  private frame = 0;

  private hasUltrathink(): boolean {
    return /ultrathink/i.test(this.getText());
  }

  private startAnimation(): void {
    if (this.animationTimer) return;
    this.animationTimer = setInterval(() => {
      this.frame++;
      this.tui.requestRender();
    }, 60);
  }

  private stopAnimation(): void {
    if (this.animationTimer) {
      clearInterval(this.animationTimer);
      this.animationTimer = undefined;
    }
  }

  handleInput(data: string): void {
    super.handleInput(data);
    if (this.hasUltrathink()) {
      this.startAnimation();
    } else {
      this.stopAnimation();
    }
  }

  render(width: number): string[] {
    const cycle = this.frame % 20;
    const shinePos = cycle < 10 ? cycle : -1;
    return super.render(width).map((line) => line.replace(/ultrathink/gi, (m) => colorize(m, shinePos)));
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setEditorComponent((tui, theme, kb) => new RainbowEditor(tui, theme, kb));
  });
}
