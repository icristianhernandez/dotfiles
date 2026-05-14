/**
 * Model Status Extension
 *
 * Displays the current model in the status bar and notifies on model changes.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("model_select", async (event, ctx) => {
    const { model, source } = event;

    if (source !== "restore") {
      ctx.ui.notify(`Model: ${model.provider}/${model.id}`, "info");
    }

    ctx.ui.setStatus("model", `\uD83E\uDD16 ${model.id}`);
  });
}
