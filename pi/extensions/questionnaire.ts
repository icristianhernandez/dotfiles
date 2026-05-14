/**
 * Questionnaire Tool Extension
 *
 * Registers a "questionnaire" tool that lets the agent ask the user
 * structured questions with options. Supports custom text input per
 * question and tab-based navigation.
 */

import type { ExtensionAPI, ExtensionContext, RegisteredTool } from "@mariozechner/pi-coding-agent";
import { Box, Text } from "@mariozechner/pi-tui";

interface Question {
  id: string;
  label: string;
  prompt: string;
  options: string[];
  allowOther?: boolean;
}

interface QuestionnaireParams {
  title?: string;
  questions: Question[];
}

interface Answer {
  id: string;
  answer: string;
}

interface QuestionnaireResult {
  answers: Answer[];
}

const questionnaireTool: RegisteredTool = {
  name: "questionnaire",
  label: "Questionnaire",
  description: "Ask the user a set of structured questions with options",
  parameters: {
    type: "object",
    properties: {
      title: { type: "string", description: "Title of the questionnaire" },
      questions: {
        type: "array",
        description: "List of questions to ask",
        items: {
          type: "object",
          properties: {
            id: { type: "string", description: "Unique identifier for this question" },
            label: { type: "string", description: "Short label for the question" },
            prompt: { type: "string", description: "The question text" },
            options: {
              type: "array",
              description: "Available answer options",
              items: { type: "string" },
            },
            allowOther: {
              type: "boolean",
              description: "Allow custom text input alongside options",
            },
          },
          required: ["id", "label", "prompt", "options"],
        },
      },
    },
    required: ["questions"],
  },
  async execute(params: QuestionnaireParams, ctx: ExtensionContext): Promise<QuestionnaireResult> {
    const answers: Answer[] = [];

    for (const question of params.questions) {
      const options = [...question.options];
      if (question.allowOther) {
        options.push("Type something\u2026");
      }

      const choice = await ctx.ui.select(`${question.label}\n${question.prompt}`, options);
      if (!choice) {
        answers.push({ id: question.id, answer: "" });
        continue;
      }

      if (choice === "Type something\u2026") {
        const text = await ctx.ui.editor(`${question.prompt}`, "");
        answers.push({ id: question.id, answer: text?.trim() || "" });
      } else {
        answers.push({ id: question.id, answer: choice });
      }
    }

    return { answers };
  },
  renderCall(params: QuestionnaireParams, theme: { fg: (color: string, text: string) => string }): string {
    const lines = [`${theme.fg("accent", "\u2753")} Questionnaire: ${params.title || "Questions"}`];
    for (const q of params.questions) {
      lines.push(theme.fg("dim", `  ${q.label}: ${q.prompt}`));
    }
    return lines.join("\n");
  },
  renderResult(
    result: QuestionnaireResult | null,
    _call: QuestionnaireParams,
    theme: { fg: (color: string, text: string) => string },
  ): string {
    if (!result?.answers) return theme.fg("dim", "  No answers collected");
    return result.answers
      .map((a) => `  ${theme.fg("success", "\u2713")} ${a.id}: ${a.answer || "(no answer)"}`)
      .join("\n");
  },
};

export default function (pi: ExtensionAPI) {
  pi.registerTool(questionnaireTool);
}
