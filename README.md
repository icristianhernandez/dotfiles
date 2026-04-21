<pre>
╔═══════════════════════════════════════╗
║                                       ║
║      N I X O S   D O T F I L E S      ║
║                                       ║
╚═══════════════════════════════════════╝
</pre>

Personal NixOS + Home Manager monorepo for multiple hosts.

## Summary

NixOS and Home Manager provide declarative system and home configuration through role-based modules.
Fish shell with Starship powers the interactive terminal; Neovim handles editing; Kitty renders it.
Various DE configured (GNOME currently principal, default)
OpenCode configured for IA usage.
Each host selects roles in `flake.nix` to compose its configuration.

## Quick start

```bash
# Rebuild a host
sudo nixos-rebuild switch --flake .#desktopthinkpad

# Run CI locally
nix run .#ci

```

## License

MIT
