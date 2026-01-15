#!/usr/bin/env python3
import json

from typing import TypeAlias

OpencodeJSON: TypeAlias = dict[
    str, str | list[str] | dict[str, int | dict[str, bool]] | dict[str, str]
]

OpencodeJSONPermissions: TypeAlias = dict[str, str | dict[str, str]]


BASE_CONFIG: OpencodeJSON = {
    "$schema": "https://opencode.ai/config.json",
    "model": "github-copilot/oswe-vscode-prime",
    "small_model": "github-copilot/grok-code-fast-1",
    "disabled_providers": ["opencode"],
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
    "autoupdate": "false",
}


def merge_permissions_deep(
    base_permissions: OpencodeJSONPermissions,
    override_permissions: OpencodeJSONPermissions,
) -> OpencodeJSONPermissions:
    """Return a new OpencodeJSONPermissions which is the deep merge of base_permissions and override_permissions.

    Inputs are not mutated; override_permissions wins.
    """
    merged: OpencodeJSONPermissions = {}

    all_keys = set(base_permissions) | set(override_permissions)

    for key in all_keys:
        if key in override_permissions:
            base_val = base_permissions.get(key)
            override_val = override_permissions[key]

            if isinstance(base_val, dict) and isinstance(override_val, dict):
                merged[key] = {**base_val, **override_val}
            else:
                merged[key] = override_val
        else:
            merged[key] = base_permissions[key]

    return merged


core_permissions = {
    "*": "ask",
    "task": "ask",
    "external_directory": "ask",
    "webfetch": "allow",
    "edit": "allow",
    "grep": "allow",
    "glob": "allow",
    "list": "allow",
    "skill": "allow",
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
        "rg *": "allow",
        "git status *": "allow",
        "cd *": "allow",
        "git diff *": "allow",
        "pwd": "allow",
        "ls *": "allow",
        "curl *": "allow",
        "wget *": "allow",
        "grep *": "allow",
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
