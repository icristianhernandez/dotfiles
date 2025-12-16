# Role helper functions for the multihost roles/profiles pattern.
#
# Usage: hasRole = roles: role: builtins.elem role roles;
#        lib.mkIf (hasRole "wsl") { ... }
{
  # Check if a role is active in the given roles list.
  # Type: [string] -> string -> bool
  hasRole = roles: role: builtins.elem role roles;
}
