#!/usr/bin/env python3
import json

from typing import TypeAlias

OpencodeJSON: TypeAlias = dict[
    str, str | list[str] | dict[str, int | dict[str, bool]] | dict[str, str]
]

OpencodeJSONPermissions: TypeAlias = dict[str, str | dict[str, str]]


BASE_CONFIG: OpencodeJSON = {
    "$schema": "https://opencode.ai/config.json",
    "model": "github-copilot/gpt-5-mini",
    "small_model": "github-copilot/grok-code-fast-1",
    # "disabled_providers": ["opencode"],
    "tui": {
        "scroll_speed": 3,
        "scroll_acceleration": {
            "enabled": False,
        },
    },
    "keybinds": {
        "messages_half_page_up": "ctrl+u",
        "messages_half_page_down": "ctrl+d",
    },
    "default_agent": "plan",
}


def merge_permissions_deep(
    base_permissions: OpencodeJSONPermissions,
    override_permissions: OpencodeJSONPermissions,
) -> OpencodeJSONPermissions:
    """Return a new OpencodeJSONPermissions merged deterministically.

    OpenCode permission configs are order-sensitive in practice (pattern matching where
    the last matching rule wins). This function preserves insertion order and ensures
    that a catch-all "*" rule stays first when present.

    Inputs are not mutated; override_permissions wins.
    """

    def star_first(d: dict[str, str]) -> dict[str, str]:
        if "*" not in d:
            return dict(d)
        ordered: dict[str, str] = {"*": d["*"]}
        for k, v in d.items():
            if k == "*":
                continue
            ordered[k] = v
        return ordered

    # Start with base (preserve insertion order)
    merged: OpencodeJSONPermissions = dict(base_permissions)

    # Apply overrides in override insertion order
    for key, override_val in override_permissions.items():
        base_val = base_permissions.get(key)

        if isinstance(base_val, dict) and isinstance(override_val, dict):
            nested = dict(base_val)
            # Overlay nested overrides preserving order
            nested.update(override_val)
            merged[key] = star_first(nested)
        else:
            merged[key] = override_val

    # Keep top-level catch-all first, if present
    if "*" in merged:
        merged = {"*": merged["*"], **{k: v for k, v in merged.items() if k != "*"}}

    return merged


core_permissions = {
    "*": "ask",
    "external_directory": "ask",
    "webfetch": "allow",
    "task": "allow",
    "codesearch": "allow",
    "lsp": "allow",
    "edit": "allow",
    "grep": "allow",
    "glob": "allow",
    "list": "allow",
    "todowrite": "allow",
    "todoread": "allow",
    "question": "allow",
    "websearch": "allow",
    "doom_loop": "deny",
    "read": {
        "*": "allow",
        "*.env": "deny",
        "*.env.*": "deny",
        "*.env.example": "allow",
    },
    "bash": {
        "*": "ask",
        "true": "allow",
        "nix run ./nixos#ci": "allow",
        "nix run ./nixos#nixos-ci": "allow",
        "nix run ./nixos#nvim-ci": "allow",
        "nix run ./nixos#workflows-ci": "allow",
        "nix run ./nixos#nixos-fmt": "allow",
        "nix run ./nixos#nixos-lint": "allow",
        "nix run ./nixos#nvim-fmt": "allow",
        "nix run ./nixos#nvim-lint": "allow",
        "nix run ./nixos#workflows-fmt": "allow",
        "nix run ./nixos#workflows-lint": "allow",
        "sqlfluff fix *": "allow",
        "sqlfluff lint *": "allow",
        "nix eval *": "allow",
        "nix search *": "allow",
        "rg": "allow",
        "rg *": "allow",
        "git status": "allow",
        "git status *": "allow",
        "cd *": "allow",
        "git diff": "allow",
        "git diff *": "allow",
        "pwd": "allow",
        "ls": "allow",
        "ls *": "allow",
        "curl *": "allow",
        "wget *": "allow",
        "grep": "allow",
        "grep *": "allow",
        "mmdc": "allow",
        "mmdc *": "allow",
        "*git push*": "deny",
        "*git commit*": "deny",
    },
}

build_agent_specific_permissions: OpencodeJSONPermissions = {}
plan_agent_specific_permissions: OpencodeJSONPermissions = {
    "edit": "deny",
    "external_directory": "allow",
}

opencode_json = {
    **BASE_CONFIG,
    "agent": {
        # "general": {
        #     "model": "github-copilot/gpt-5-mini",
        # },
        # "explore": {
        #     "model": "github-copilot/gpt-5-mini",
        # },
        # "compaction": {
        #     "model": "github-copilot/gpt-5-mini",
        # },
        # "summary": {
        #     "model": "github-copilot/gpt-5-mini",
        # },
        "build": {
            "permission": merge_permissions_deep(
                core_permissions, build_agent_specific_permissions
            )
        },
        "plan": {
            "permission": merge_permissions_deep(
                core_permissions, plan_agent_specific_permissions
            )
        },
    },
}

with open("opencode.json", "w") as opened_file:
    json.dump(opencode_json, opened_file, indent=4)
