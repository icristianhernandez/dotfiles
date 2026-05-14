/**
 * Notify Extension
 *
 * Sends desktop notifications when:
 * - Agent completes a turn and is waiting for input (agent_end)
 * - An action requires user approval (permission:required event)
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

function notifyOSC777(title: string, body: string): void {
  process.stdout.write(`\x1b]777;notify;${title};${body}\x07`);
}

function notifyOSC99(title: string, body: string): void {
  process.stdout.write(`\x1b]99;i=1:d=0;${title}\x1b\\`);
  process.stdout.write(`\x1b]99;i=1:p=body;${body}\x1b\\`);
}

function notifySend(title: string, body: string): void {
  const { exec } = require("child_process");
  exec(`notify-send "${title}" "${body}"`, (err: Error | null) => {
    if (err) return;
  });
}

function canberraPlay(sound: string): void {
  const { exec } = require("child_process");
  exec(`canberra-gtk-play -i ${sound}`, () => {});
}

function notify(title: string, body: string): void {
  if (process.env.WT_SESSION) {
    notifySend(title, body);
  } else if (process.env.KITTY_WINDOW_ID) {
    notifyOSC99(title, body);
  } else {
    notifyOSC777(title, body);
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async () => {
    notify("Pi", "Ready for input");
  });

  pi.events.on("permission:required", (data) => {
    const { toolName, reason } = data as { toolName: string; reason: string };
    notify("Pi \u2014 Approval Required", `${toolName}: ${reason}`);
  });
}
