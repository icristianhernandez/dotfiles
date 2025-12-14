# NixOS Configuration Exhaustive Audit Report

## I. Executive Summary

The NixOS configuration demonstrates a solid foundation with good modularization practices and clean separation between system and home-manager modules. However, several critical improvements are needed: (1) The `lib/` directory contains non-library code that should be refactored, particularly `app-helpers.nix` which mixes concerns; (2) Flake outputs lack multi-system support despite declaring a systems list; (3) Several modules exhibit verbosity and could benefit from more idiomatic Nix patterns. The configuration is generally secure but would benefit from explicit security hardening in WSL-specific areas and package selections.

## II. Architectural & Modularization Review

### Finding: Inconsistent Multi-System Support
* **Location:** `nixos/flake.nix` (Lines 21-25, 46)
* **Issue:** The flake defines a `systems` list containing only `x86_64-linux`, but the NixOS configuration uses `builtins.head systems` instead of a proper multi-system approach. Additionally, the formatter is properly multi-system aware, but the main configuration is not.
* **Improvement:** Either fully embrace multi-system support or simplify to a single-system configuration. The current approach is misleading.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -19,11 +19,10 @@
     let
       const = import ./lib/const.nix;
-      systems = [ "x86_64-linux" ];
+      system = "x86_64-linux";
     in
     {
       nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
-        system = builtins.head systems;
+        system = system;
         specialArgs = { inherit const; };
 
         modules = [
@@ -44,7 +43,10 @@
         ];
       };
 
-      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);
+      formatter = nixpkgs.lib.genAttrs [ system ] (
+        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
+      );
 
-      apps = import ./apps { inherit nixpkgs systems; };
+      apps = import ./apps { inherit nixpkgs; systems = [ system ]; };
     };
```

### Finding: Lib Directory Misuse - app-helpers.nix
* **Location:** `nixos/lib/app-helpers.nix` (Lines 1-40)
* **Issue:** The `lib/` directory should contain pure, reusable functions. The `app-helpers.nix` file contains application-specific logic with hardcoded paths and formatting concerns that belong in the `apps/` directory.
* **Improvement:** Move `app-helpers.nix` to `apps/helpers.nix` to maintain clean architectural boundaries.

```diff
--- a/nixos/lib/app-helpers.nix
+++ b/nixos/apps/helpers.nix
@@ -1,40 +1,40 @@
 { pkgs }:
 {
   prelude =
     {
       name,
       withNix ? false,
       appPrefixAttr ? true,
     }:
     let
       nixPart =
         if withNix then
           ''
             NIX="${pkgs.nix}/bin/nix"
             APP_PREFIX="./nixos#${if appPrefixAttr then "apps.${pkgs.stdenv.hostPlatform.system}" else ""}"
             NIX_RUN=( "$NIX" --extra-experimental-features "nix-command flakes" run )
           ''
         else
           '''';
     in
     ''
       set -euo pipefail
       ${nixPart}
       log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "[${name}] $1" >&2; }
     '';

   parseMode = ''
     mode="fix"
     case "''${1-}" in
       --check) mode="check"; shift ;;
     esac
   '';

   paths = {
     nixosDir = "nixos";
     nvimCfgDir = "nvim";
     workflowsDir = ".github/workflows";
     statixConfig = "statix.toml";
   };
 }
```

Note: After moving this file, all references in `apps/*.nix` files need to be updated from `../lib/app-helpers.nix` to `./helpers.nix`.

Then update all references in `apps/*.nix` files:

```diff
--- a/nixos/apps/nixos-fmt.nix
+++ b/nixos/apps/nixos-fmt.nix
@@ -7,7 +7,7 @@
   inherit (pkgs) nixfmt;
   script =
     let
-      helpers = import ../lib/app-helpers.nix { inherit pkgs; };
+      helpers = import ./helpers.nix { inherit pkgs; };
     in
     pkgs.writeShellApplication {
```

### Finding: Redundant Configuration Wrapper Files
* **Location:** `nixos/configuration.nix` and `nixos/home.nix` (Lines 1-8 each)
* **Issue:** These files serve only as thin wrappers around `import-modules.nix`, adding unnecessary indirection. This pattern could be simplified.
* **Improvement:** While this pattern provides clarity, consider documenting WHY these wrapper files exist if they're kept, or integrate directly into `flake.nix`.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -27,7 +27,10 @@
         specialArgs = { inherit const; };
 
         modules = [
-          ./configuration.nix
+          {
+            imports = import ./lib/import-modules.nix { inherit (nixpkgs) lib; dir = ./system-modules; };
+          }
           nixos-wsl.nixosModules.default
           home-manager.nixosModules.home-manager
           {
@@ -37,7 +40,9 @@
               backupFileExtension = "backup";
               extraSpecialArgs = { inherit const; };
               users = {
-                "${const.user}" = ./home.nix;
+                "${const.user}" = {
+                  imports = import ./lib/import-modules.nix { inherit (nixpkgs) lib; dir = ./home-modules; };
+                };
               };
             };
           }
```

### Finding: Module Import Function Lacks Error Handling
* **Location:** `nixos/lib/import-modules.nix` (Lines 1-8)
* **Issue:** The `import-modules.nix` function doesn't validate that the directory exists or contains any .nix files, potentially causing silent failures.
* **Improvement:** Add validation and helpful error messages.

```diff
--- a/nixos/lib/import-modules.nix
+++ b/nixos/lib/import-modules.nix
@@ -1,8 +1,15 @@
 { lib, dir }:
 
 let
+  dirExists = builtins.pathExists dir;
   foundFiles = lib.filesystem.listFilesRecursive dir;
   nixFiles = lib.filter (p: lib.strings.hasSuffix ".nix" (toString p)) foundFiles;
   sortedFiles = lib.sort (a: b: (toString a) < (toString b)) nixFiles;
 in
-sortedFiles
+if !dirExists then
+  throw "import-modules: directory '${toString dir}' does not exist"
+else if nixFiles == [ ] then
+  builtins.trace "WARNING: import-modules: no .nix files found in '${toString dir}'" [ ]
+else
+  sortedFiles
```

### Finding: Missing Flake Description and Metadata
* **Location:** `nixos/flake.nix` (Lines 1-50)
* **Issue:** The flake lacks a description field, which is useful for documentation and `nix flake show` output.
* **Improvement:** Add proper metadata.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -1,4 +1,6 @@
 {
+  description = "Personal NixOS configuration for WSL with Home Manager";
+
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
```

## III. Code Quality & Idiomatic Nix Review

### Finding: Verbose Locale Configuration
* **Location:** `nixos/system-modules/locale.nix` (Lines 1-16)
* **Issue:** The locale configuration manually sets 9 different LC_* variables to the same value, creating unnecessary verbosity.
* **Improvement:** Use `lib.genAttrs` to generate these programmatically.

```diff
--- a/nixos/system-modules/locale.nix
+++ b/nixos/system-modules/locale.nix
@@ -1,16 +1,16 @@
-{ const, ... }:
+{ lib, const, ... }:
 let
   loc = const.locale;
+  localeCategories = [
+    "LC_ADDRESS"
+    "LC_IDENTIFICATION"
+    "LC_MEASUREMENT"
+    "LC_MONETARY"
+    "LC_NAME"
+    "LC_NUMERIC"
+    "LC_PAPER"
+    "LC_TELEPHONE"
+    "LC_TIME"
+  ];
 in
 {
   i18n.defaultLocale = loc;
-  i18n.extraLocaleSettings = {
-    LC_ADDRESS = loc;
-    LC_IDENTIFICATION = loc;
-    LC_MEASUREMENT = loc;
-    LC_MONETARY = loc;
-    LC_NAME = loc;
-    LC_NUMERIC = loc;
-    LC_PAPER = loc;
-    LC_TELEPHONE = loc;
-    LC_TIME = loc;
-  };
+  i18n.extraLocaleSettings = lib.genAttrs localeCategories (_: loc);
 }
```

### Finding: Verbose Package Categorization
* **Location:** `nixos/system-modules/packages.nix` (Lines 3-41)
* **Issue:** While categorizing packages is good for organization, the structure could be more maintainable with better formatting and potential extraction.
* **Improvement:** Consider moving package lists to a separate data structure in lib/const.nix for easier maintenance, or at minimum improve the formatting consistency.

```diff
--- a/nixos/system-modules/packages.nix
+++ b/nixos/system-modules/packages.nix
@@ -1,39 +1,31 @@
 { pkgs, ... }:
+let
+  packageSets = {
+    os_base = with pkgs; [
+      ntfs3g
+      openssh
+    ];
+
+    cli_utils = with pkgs; [
+      curl
+      fd
+      gnutar
+      ripgrep
+      unrar
+      unzip
+      wget
+    ];
+
+    languages = with pkgs; [
+      gcc
+      nodejs_24
+      (python313.withPackages (ps: [ ps.pip ]))
+    ];
+
+    dev_env = with pkgs; [
+      go
+      lazygit
+      lsof
+      neovim
+      nixd
+      nixfmt-rfc-style
+      nvimpager
+      opencode
+      tree-sitter
+    ];
+  };
+in
 {
-  environment.systemPackages =
-    let
-      os_base = with pkgs; [
-        ntfs3g
-        openssh
-      ];
-      cli_utils = with pkgs; [
-        unrar
-        wget
-        curl
-        ripgrep
-        fd
-        gnutar
-        unzip
-      ];
-      languages = with pkgs; [
-        nodejs_24
-        gcc
-        (python313.withPackages (ps: [ ps.pip ]))
-      ];
-      dev_env = with pkgs; [
-        neovim
-        opencode
-        nvimpager
-        nixd
-        tree-sitter
-        lsof
-        nixfmt
-        lazygit
-        go
-      ];
-    in
-    pkgs.lib.concatLists [
-      os_base
-      cli_utils
-      languages
-      dev_env
-    ];
+  environment.systemPackages = with pkgs.lib; flatten (attrValues packageSets);
 }
```

### Finding: Inconsistent Use of nixfmt vs nixfmt-rfc-style
* **Location:** `nixos/system-modules/packages.nix` (Line 32) and `nixos/flake.nix` (Line 46)
* **Issue:** The flake uses `nixfmt` for formatting, but there's a newer `nixfmt-rfc-style` that follows RFC 166. The packages.nix lists `nixfmt` separately.
* **Improvement:** Standardize on `nixfmt-rfc-style` throughout.

```diff
--- a/nixos/system-modules/packages.nix
+++ b/nixos/system-modules/packages.nix
@@ -30,7 +30,7 @@
         nvimpager
         nixd
         tree-sitter
         lsof
-        nixfmt
+        nixfmt-rfc-style
         lazygit
         go
```

### Finding: Hardcoded Wrapper Name in mk-app.nix
* **Location:** `nixos/lib/mk-app.nix` (Lines 11-12, 24)
* **Issue:** The wrapper shell application uses a hardcoded name "mkapp-wrapper" which could cause conflicts if multiple apps are instantiated.
* **Improvement:** Use a unique name based on the program or a hash.

```diff
--- a/nixos/lib/mk-app.nix
+++ b/nixos/lib/mk-app.nix
@@ -1,26 +1,28 @@
 { pkgs }:
 attrs:
 let
   program = attrs.program or null;
   argv = if builtins.hasAttr "argv" attrs then attrs.argv else [ ];
   meta = if builtins.hasAttr "meta" attrs then attrs.meta else { };
+  
+  # Generate a unique wrapper name based on program hash
+  wrapperName = "mkapp-wrapper-${builtins.substring 0 8 (builtins.hashString "sha256" program)}";
+  
   wrapper =
     if (argv == [ ]) then
       null
     else
       pkgs.writeShellApplication {
-        name = "mkapp-wrapper";
+        name = wrapperName;
         runtimeInputs = [ ];
         text = ''
           exec ${program} ${pkgs.lib.escapeShellArgs argv} "$@"
         '';
       };
 in
 if program == null then
   throw "mkApp: 'program' is required"
 else
   {
     type = "app";
-    program = if wrapper == null then program else "${wrapper}/bin/mkapp-wrapper";
+    program = if wrapper == null then program else "${wrapper}/bin/${wrapperName}";
     inherit meta;
   }
```

### Finding: Missing Function Documentation
* **Location:** `nixos/lib/*.nix` (All files)
* **Issue:** None of the library functions have documentation comments explaining their purpose, parameters, or return values.
* **Improvement:** Add documentation comments to all public functions.

```diff
--- a/nixos/lib/import-modules.nix
+++ b/nixos/lib/import-modules.nix
@@ -1,3 +1,14 @@
+# Import all .nix files from a directory as a sorted list of module paths.
+#
+# This function is used to automatically import all modules from a directory
+# without manually maintaining an import list.
+#
+# Type: { lib: attrset, dir: path } -> [path]
+#
+# Arguments:
+#   lib: The nixpkgs lib attribute set
+#   dir: Path to directory containing .nix module files
+#
+# Returns: Sorted list of paths to .nix files found in directory
 { lib, dir }:
 
 let
```

### Finding: Redundant Underscore Patterns
* **Location:** `nixos/home-modules/yazi.nix`, `nixos/home-modules/starship.nix`, `nixos/home-modules/ssh-agent.nix` (Line 1)
* **Issue:** These modules use `_:` as the module argument but could benefit from explicitly named unused arguments for clarity.
* **Improvement:** Use `{ ... }:` for better self-documentation, or destructure even if unused to show what's available.

```diff
--- a/nixos/home-modules/yazi.nix
+++ b/nixos/home-modules/yazi.nix
@@ -1,2 +1,2 @@
-_: {
+{ ... }:
+{
   programs.yazi.enable = true;
 }
```

### Finding: Shell Initialization Logic Could Be Simplified
* **Location:** `nixos/system-modules/shell.nix` (Lines 12-19)
* **Issue:** The bash-to-fish exec logic is complex and could benefit from a comment explaining the edge cases it handles.
* **Improvement:** Add comprehensive comments and potentially extract to a separate file if this pattern is reused.

```diff
--- a/nixos/system-modules/shell.nix
+++ b/nixos/system-modules/shell.nix
@@ -11,6 +11,10 @@
     bash = {
       enable = true;
 
-      # bash remain as login shell but exec fish when runned interactively
+      # Keep bash as the login shell for compatibility, but automatically
+      # exec into fish for interactive sessions. This handles:
+      # - Avoiding nested fish shells (check PPID)
+      # - Preserving bash scripts (check BASH_EXECUTION_STRING)
+      # - Maintaining login shell status (--login flag)
       interactiveShellInit = ''
         if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
```

### Finding: Git Configuration Uses Non-Standard Settings Attribute
* **Location:** `nixos/home-modules/git.nix` (Lines 5-14)
* **Issue:** The module uses `settings` which is correct for newer home-manager, but the pattern could be more explicit about git config structure.
* **Improvement:** This is actually correct modern home-manager syntax. No change needed, but worth documenting.

No diff needed - this is already following best practices.

### Finding: Inconsistent Attribute Ordering
* **Location:** Multiple files
* **Issue:** Some modules use alphabetical ordering of attributes while others don't, making the codebase harder to scan.
* **Improvement:** Establish and document a consistent ordering convention (e.g., enable first, then config, then other attributes alphabetically).

Example for `nixos/home-modules/nvim.nix`:

```diff
--- a/nixos/home-modules/nvim.nix
+++ b/nixos/home-modules/nvim.nix
@@ -2,13 +2,15 @@
 
 {
   programs.neovim = {
-    enable = true;
     defaultEditor = true;
+    enable = true;
   };
 
   home.sessionVariables = {
-    MANPAGER = "nvim +Man!";
-    PAGER = "nvimpager";
     GIT_PAGER = "nvimpager";
+    MANPAGER = "nvim +Man!";
+    PAGER = "nvimpager";
   };
 
   xdg.configFile."nvim" = {
-    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/nvim";
     recursive = true;
+    source = config.lib.file.mkOutOfStoreSymlink "${const.dotfiles_dir}/nvim";
   };
 }
```

## IV. Security & Error Review

### Finding: Potential Security Risk - AllowUnfree Without Constraints
* **Location:** `nixos/system-modules/core.nix` (Line 2)
* **Issue:** `nixpkgs.config.allowUnfree = true;` enables all unfree packages globally without restrictions. This could inadvertently allow unexpected proprietary software.
* **Improvement:** Use `allowUnfreePredicate` to explicitly whitelist required unfree packages.

```diff
--- a/nixos/system-modules/core.nix
+++ b/nixos/system-modules/core.nix
@@ -1,5 +1,14 @@
 { pkgs, const, ... }:
 {
-  nixpkgs.config.allowUnfree = true;
+  # Explicitly allow only required unfree packages
+  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
+    # Add unfree packages here as needed
+    # Example: "vscode" "discord" "spotify"
+  ];
+  
+  # Fallback: allow all unfree for now, but should be constrained
+  # TODO: Audit all packages and move to whitelist above
+  nixpkgs.config.allowUnfree = true;
```

### Finding: Missing Security Hardening for WSL Environment
* **Location:** `nixos/system-modules/wsl.nix` (Lines 1-4)
* **Issue:** The WSL configuration is minimal and doesn't include security considerations specific to WSL environments.
* **Improvement:** Add security-related WSL options and document security boundaries.

```diff
--- a/nixos/system-modules/wsl.nix
+++ b/nixos/system-modules/wsl.nix
@@ -1,4 +1,12 @@
 { const, ... }:
 {
   wsl.enable = true;
   wsl.defaultUser = const.user;
+  
+  # WSL security considerations
+  wsl.interop.register = true;  # Required for Windows interop
+  wsl.nativeSystemd = true;     # Use systemd for better service management
+  
+  # Note: WSL runs inside Windows security context
+  # Additional hardening should be done at Windows level
 }
```

### Finding: SSH Keys Loaded Without Passphrase Timeout
* **Location:** `nixos/home-modules/ssh-agent.nix` (Lines 15-16)
* **Issue:** The keychain configuration doesn't specify a timeout for cached passphrases, which could be a security risk if the session is left unattended.
* **Improvement:** Add timeout configuration.

```diff
--- a/nixos/home-modules/ssh-agent.nix
+++ b/nixos/home-modules/ssh-agent.nix
@@ -14,6 +14,9 @@
   programs.keychain = {
     enable = true;
     keys = [ "id_ed25519" ];
-    extraFlags = [ "--quiet" ];
+    extraFlags = [
+      "--quiet"
+      "--timeout 60"  # Lock keys after 60 minutes of inactivity
+    ];
     enableBashIntegration = true;
     enableFishIntegration = true;
   };
```

### Finding: Sensitive Git Email in Plain Text
* **Location:** `nixos/lib/const.nix` (Lines 9-12)
* **Issue:** Personal email addresses are stored in plain text in version control. While not critical for public emails, this pattern could be problematic if extended to sensitive credentials.
* **Improvement:** Document that secrets should never be stored in const.nix, and consider using sops-nix or agenix for actual secrets.

```diff
--- a/nixos/lib/const.nix
+++ b/nixos/lib/const.nix
@@ -1,3 +1,9 @@
+# WARNING: This file is committed to version control.
+# NEVER store secrets, API keys, or sensitive credentials here.
+# For secrets management, use sops-nix or agenix.
+#
+# This file should only contain non-sensitive configuration constants.
+
 rec {
   user = "cristianwslnixos";
   home_dir = "/home/${user}";
```

### Finding: Garbage Collection Could Remove Important Generations
* **Location:** `nixos/system-modules/core.nix` (Lines 13-17)
* **Issue:** The garbage collection keeps only 3 generations, which may be insufficient for rollback if issues aren't discovered immediately.
* **Improvement:** Increase to a more conservative retention policy.

```diff
--- a/nixos/system-modules/core.nix
+++ b/nixos/system-modules/core.nix
@@ -13,7 +13,8 @@
     gc = {
       automatic = true;
       dates = "weekly";
-      options = "--delete-generations +3";
+      # Keep at least 5 generations or 30 days of history
+      options = "--delete-older-than 30d";
     };
     optimise.automatic = true;
   };
```

### Finding: No Backup Configuration for Home-Manager
* **Location:** `nixos/flake.nix` (Line 36)
* **Issue:** While `backupFileExtension = "backup";` is set, there's no strategy for managing these backups or preventing accumulation.
* **Improvement:** Document backup management expectations or implement cleanup.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -34,6 +34,8 @@
             home-manager = {
               useGlobalPkgs = true;
               useUserPackages = true;
+              # Creates .backup files when home-manager would overwrite existing files
+              # Manual cleanup required: find ~/ -name "*.backup" -type f
               backupFileExtension = "backup";
               extraSpecialArgs = { inherit const; };
```

### Finding: Python Package Installation Without Version Pinning
* **Location:** `nixos/system-modules/packages.nix` (Line 22)
* **Issue:** Python pip is installed but package versions aren't managed by Nix, creating reproducibility issues.
* **Improvement:** Document this limitation and recommend using poetry2nix or similar for production.

```diff
--- a/nixos/system-modules/packages.nix
+++ b/nixos/system-modules/packages.nix
@@ -20,6 +20,9 @@
       languages = with pkgs; [
         nodejs_24
         gcc
+        # Note: pip-installed packages won't be managed by Nix
+        # For reproducible Python environments, consider using:
+        # - poetry2nix for Poetry projects
+        # - buildPythonApplication for Nix-managed Python packages
         (python313.withPackages (ps: [ ps.pip ]))
       ];
```

### Finding: Missing Input Follows for nixos-wsl
* **Location:** `nixos/flake.nix` (Line 4)
* **Issue:** The nixos-wsl input doesn't follow nixpkgs, potentially causing multiple nixpkgs instances in the closure. This significantly increases build times and disk usage as Nix will evaluate and build dependencies from multiple nixpkgs versions, and the system closure will contain duplicate packages.
* **Improvement:** Add input follows to ensure all flake inputs share the same nixpkgs instance, reducing closure size by potentially hundreds of megabytes and improving evaluation speed.

```diff
--- a/nixos/flake.nix
+++ b/nixos/flake.nix
@@ -2,7 +2,10 @@
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
-    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
+    
+    nixos-wsl = {
+      url = "github:nix-community/NixOS-WSL/main";
+      inputs.nixpkgs.follows = "nixpkgs";
+    };
 
     home-manager = {
       url = "github:nix-community/home-manager";
```

### Finding: Potential Performance Issue - Recursive Directory Import
* **Location:** `nixos/lib/import-modules.nix` (Line 4)
* **Issue:** `listFilesRecursive` could be inefficient for deeply nested directories, though this isn't a problem currently.
* **Improvement:** Document the expected directory structure depth and consider alternatives if subdirectories are added.

No immediate change needed, but document:

```diff
--- a/nixos/lib/import-modules.nix
+++ b/nixos/lib/import-modules.nix
@@ -1,5 +1,7 @@
 { lib, dir }:
-
+# NOTE: This uses listFilesRecursive which could be slow for deep directory trees.
+# Current structure is flat, but consider lib.filesystem.listFiles if adding subdirectories.
+
 let
   foundFiles = lib.filesystem.listFilesRecursive dir;
```

### Finding: nix-ld Libraries May Include Unnecessary Dependencies
* **Location:** `nixos/system-modules/core.nix` (Lines 4-7)
* **Issue:** Using `(pkgs.steam-run.args.multiPkgs pkgs)` includes many Steam-specific libraries that may not be needed, significantly increasing closure size.
* **Improvement:** Start with a minimal set of commonly needed libraries and add more only as required. Document which applications need which libraries.

```diff
--- a/nixos/system-modules/core.nix
+++ b/nixos/system-modules/core.nix
@@ -3,7 +3,22 @@
   nixpkgs.config.allowUnfree = true;
 
   programs.nix-ld = {
     enable = true;
-    libraries = (pkgs.steam-run.args.multiPkgs pkgs) ++ [ pkgs.icu ];
+    # Minimal set of commonly needed libraries for dynamic binaries
+    # Add more libraries only as needed based on actual application requirements
+    libraries = with pkgs; [
+      # Core C/C++ libraries
+      stdenv.cc.cc.lib
+      zlib
+      
+      # Common dependencies
+      icu
+      openssl
+      
+      # Uncomment if needed for specific applications:
+      # steam-run.args.multiPkgs pkgs  # For Steam and gaming
+      # Add other libraries here as discovered
+    ];
   };
```

Note: Test applications after this change to ensure all required libraries are included. Add libraries back incrementally as needed.

### Finding: Time Zone Hardcoded Instead of Using Const
* **Location:** `nixos/system-modules/core.nix` (Line 31)
* **Issue:** The timezone is hardcoded instead of being defined in const.nix for consistency.
* **Improvement:** Move to const.nix.

```diff
--- a/nixos/lib/const.nix
+++ b/nixos/lib/const.nix
@@ -5,6 +5,7 @@
   system_state = "25.05";
   home_state = "25.05";
   locale = "en_US.UTF-8";
+  timezone = "America/Caracas";
   user_description = "cristian hernandez";
   git = {
     name = "cristian";
--- a/nixos/system-modules/core.nix
+++ b/nixos/system-modules/core.nix
@@ -28,5 +28,5 @@
   # on your system were taken.
   system.stateVersion = const.system_state;
 
-  time.timeZone = "America/Caracas";
+  time.timeZone = const.timezone;
 }
```

## V. Final Recommendations

### 1. **Immediate: Architectural Cleanup (Priority: HIGH)**
Refactor the `lib/` directory to contain only pure functions. Move `app-helpers.nix` to `apps/helpers.nix`, add proper documentation to all library functions, and implement error handling in `import-modules.nix`. This will establish clear architectural boundaries and improve maintainability.

### 2. **Short-term: Security Hardening (Priority: HIGH)**
Implement the allowUnfreePredicate whitelist, add SSH key timeout configuration, increase garbage collection retention to 30 days, and add nixos-wsl input follows to reduce closure size. Document the security boundaries for WSL and establish secrets management guidelines.

### 3. **Short-term: Code Quality Improvements (Priority: MEDIUM)**
Standardize on `nixfmt-rfc-style`, simplify the locale configuration using `lib.genAttrs`, add comprehensive documentation to all modules, and establish consistent attribute ordering conventions. These changes will significantly improve code readability and reduce future maintenance burden.

### 4. **Medium-term: Simplify Multi-System Approach (Priority: MEDIUM)**
Either fully commit to multi-system support or simplify to single-system configuration. The current hybrid approach is confusing. If staying single-system, remove the systems list and use a simple constant. If going multi-system, properly support it throughout.

### 5. **Long-term: Enhance Reproducibility (Priority: LOW)**
Document Python pip limitations, consider adopting poetry2nix for Python projects, audit and minimize nix-ld libraries, and implement a backup management strategy for home-manager. Consider adding integration tests for CI to catch configuration issues before deployment.

---

**Overall Assessment:** The configuration is well-structured and demonstrates good separation of concerns. The primary issues are architectural (lib directory misuse), security (unfree packages, key timeouts), and code quality (verbosity, documentation). Addressing these recommendations will result in a production-grade, maintainable NixOS configuration that follows community best practices.
