# NixOS Configuration Exhaustive Audit Report

## I. Executive Summary
The current flake cleanly wires roles and hosts but has brittle module discovery and duplicated argument plumbing. Resilience can improve by guarding dynamic imports before evaluation. SSH hardening is needed because default configs are disabled without explicit host-key policies. Closure size for `nix-ld` is larger than necessary due to `steam-run` defaults. Top priorities: (1) fix module importer pre-checks, (2) deduplicate shared `specialArgs`, (3) harden SSH defaults and slim `nix-ld` libraries.

## II. Architectural & Modularization Review
- `flake.nix` defines a single host and central roles pipeline; `specialArgs` and `home-manager.extraSpecialArgs` are duplicated, risking drift and making new hosts noisy to add. Extracting a shared set improves clarity and reuse.
- Module auto-import uses `lib/import-modules.nix`, but it evaluates `listFilesRecursive` before confirming the directory exists. This causes impure failures on missing paths and makes reuse in other contexts fragile. Reordering the guard preserves purity and keeps the helper reusable.
- `lib/` holds helpers only (good separation), but `import-modules.nix` could be more defensive to avoid accidentally importing hidden build artifacts because it recurses everything. Consider filtering to top-level `.nix` files when the tree grows.

### Shared specialArgs extraction
* **Location:** `[nixos/flake.nix]` (Approx. Line 56)
* **Issue:** `specialArgs` and `home-manager.extraSpecialArgs` duplicate the same attrset, inviting drift and harder host reuse.
* **Improvement:** Introduce a `commonSpecialArgs` binding and reuse it in both places to keep extensions consistent.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -56,9 +56,11 @@
         let
           host = hosts.${hostName};
           inherit (host) roles;
           helpers = rolesSpec.mkHelpers roles;
+          commonSpecialArgs = {
+            inherit const roles hostName;
+            inherit (helpers) hasRole mkIfRole guardRole;
+          };
         in
         assert rolesSpec.validateRoles roles;
         lib.nixosSystem {
           inherit (host) system;
-          specialArgs = {
-            inherit const roles hostName;
-            inherit (helpers) hasRole mkIfRole guardRole;
-          };
+          specialArgs = commonSpecialArgs;

@@
                 useGlobalPkgs = true;
                 useUserPackages = true;
                 backupFileExtension = "backup";
-                extraSpecialArgs = {
-                  inherit const roles hostName;
-                  inherit (helpers) hasRole mkIfRole guardRole;
-                };
+                extraSpecialArgs = commonSpecialArgs;
                 users = {
                   "${const.user}" = {
```

### Harden module importer guard
* **Location:** `[nixos/lib/import-modules.nix]` (Approx. Line 16)
* **Issue:** `lib.filesystem.listFilesRecursive` runs before verifying the directory exists, so a missing path throws before the intended guard, reducing purity and reuse.
* **Improvement:** Check for existence first, then enumerate files inside the true branch.

```diff
--- a/nixos/lib/import-modules.nix
+++ b/nixos/lib/import-modules.nix
@@ -16,12 +16,17 @@
-let
-  dirExists = builtins.pathExists dir;
-  foundFiles = lib.filesystem.listFilesRecursive dir;
-  nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
-  sortedFiles = lib.sort (a: b: (toString a) < (toString b)) nixFiles;
-in
-if !dirExists then
-  throw "import-modules: directory '${toString dir}' does not exist"
-else if nixFiles == [ ] then
-  builtins.trace "WARNING: import-modules: no .nix files found in '${toString dir}'" [ ]
-else
-  sortedFiles
+let
+  dirExists = builtins.pathExists dir;
+in
+if !dirExists then
+  throw "import-modules: directory '${toString dir}' does not exist"
+else
+  let
+    foundFiles = lib.filesystem.listFilesRecursive dir;
+    nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
+    sortedFiles = lib.sort (a: b: (toString a) < (toString b)) nixFiles;
+  in
+  if nixFiles == [ ] then
+    builtins.trace "WARNING: import-modules: no .nix files found in '${toString dir}'" [ ]
+  else
+    sortedFiles
```

## III. Code Quality & Idiomatic Nix Review
- Option wiring is generally terse, but some modules disable defaults without replacing them. Prefer `lib.mkIf`/guards (already used) and extract common values to avoid copy/paste.
- `programs.ssh` in Home Manager disables defaults and sets a narrow option set; readability and safety improve by explicitly pinning host-key handling and identities.

### Explicit SSH defaults after disabling upstream config
* **Location:** `[nixos/home-modules/ssh-agent.nix]` (Approx. Line 4)
* **Issue:** Upstream defaults are disabled, yet critical safety toggles (strict host key checks, identities scoping, known_hosts path) are not re-declared, relying on implicit SSH defaults.
* **Improvement:** Add explicit hardening options to keep behavior deterministic and safer.

```diff
--- a/nixos/home-modules/ssh-agent.nix
+++ b/nixos/home-modules/ssh-agent.nix
@@ -4,9 +4,13 @@
   programs.ssh = {
     enable = true;
     enableDefaultConfig = false;
     matchBlocks = {
       "*" = {
         extraOptions = {
           "AddKeysToAgent" = "ask";
           "HashKnownHosts" = "yes";
+          "StrictHostKeyChecking" = "accept-new";
+          "UserKnownHostsFile" = "~/.ssh/known_hosts";
+          "IdentitiesOnly" = "yes";
           "VerifyHostKeyDNS" = "yes";
           "ForwardAgent" = "no";
           "ForwardX11" = "no";
         };
       };
```

## IV. Security & Error Review
- `import-modules.nix` pre-check ordering is a latent error source; the guard change above prevents premature evaluation failures.
- `programs.nix-ld.libraries` currently pulls `steam-run.args.multiPkgs`, which drags a large runtime closure (including GUI/Steam bits) into non-gaming hosts. Replace with a minimal library set to shrink attack surface and closure size.

### Trim nix-ld runtime footprint
* **Location:** `[nixos/system-modules/core.nix]` (Approx. Line 8)
* **Issue:** Using `steam-run.args.multiPkgs` bloats the `nix-ld` runtime closure and brings unnecessary binaries into all base roles.
* **Improvement:** Limit `nix-ld.libraries` to a focused set of common runtimes; extend per-host if needed.

```diff
--- a/nixos/system-modules/core.nix
+++ b/nixos/system-modules/core.nix
@@ -8,7 +8,9 @@
   programs.nix-ld = {
     enable = true;
-    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ];
+    libraries = with pkgs; [
+      stdenv.cc.cc
+      glibc
+      icu
+    ];
   };
```

## V. Final Recommendations
1. Apply the `import-modules.nix` guard fix to keep module discovery pure and reusable across directories.
2. Refactor `flake.nix` to share `commonSpecialArgs`, reducing duplication when adding new hosts or roles.
3. Harden SSH defaults in `home-modules/ssh-agent.nix` to avoid silent fallback to upstream defaults after disabling them.
4. Replace `steam-run` in `nix-ld.libraries` with a minimal set to shrink closures and reduce unnecessary runtime surface.
5. When adding more hosts/modules, consider switching `import-modules` to a non-recursive, filtered import list to avoid hidden files and improve deterministic ordering.
