# NixOS Multihost Refactor Plan: Roles & Profiles Architecture

**Author:** Senior NixOS Systems Architect  
**Date:** 2025-12-16  
**Philosophy:** "Worse is Better" + KISS (Keep It Simple, Stupid)

---

## 1. Objectives, Scope, and Success Criteria

### Objectives

1. **Enable multihost configuration** with minimal code duplication
2. **Implement Roles & Profiles pattern** using standard NixOS mechanisms
3. **Maintain simplicity** - avoid custom abstractions when standard `lib.mkIf` suffices
4. **Single source of truth** for host capabilities defined in `flake.nix`

### Scope

**In Scope:**
- Create `hosts/` directory structure for per-host configuration
- Implement role-based module activation via `specialArgs`
- Categorize existing modules into logical roles
- Update `flake.nix` to support multiple hosts with role definitions
- Maintain backward compatibility with existing configuration

**Out of Scope:**
- Complex custom library wrappers
- Deep directory nesting or over-abstraction
- Changes to Neovim configuration (`nvim/` directory)
- Changes to CI/build system (`apps/` directory)
- Deployment automation (colmena, deploy-rs, etc.)

### Success Criteria

✅ **A host can be defined by simply listing its roles in `flake.nix`**

Example:
```nix
hosts.workstation = {
  roles = [ "base" "desktop" "development" ];
};

hosts.server = {
  roles = [ "base" "server" "docker" ];
};
```

✅ **Modules conditionally activate based on assigned roles**

✅ **No code duplication across host configurations**

✅ **Clear, readable structure - understanding a setting requires at most 2 file lookups**

---

## 2. Current Configuration Audit

### Repository Structure

```
nixos/
├── flake.nix                 # Single host definition (nixos)
├── lib/
│   ├── const.nix            # User constants (hardcoded for one user)
│   ├── import-modules.nix   # Auto-imports all .nix files from directory
│   └── mk-app.nix           # CI/build helper
├── system-modules/          # 6 system-level modules (all auto-imported)
│   ├── core.nix            # Nix settings, GC, timezone
│   ├── locale.nix          # i18n settings
│   ├── packages.nix        # System packages
│   ├── shell.nix           # Fish, Starship, Bash
│   ├── users.nix           # User account creation
│   └── wsl.nix             # WSL-specific configuration
└── home-modules/           # 8 home-manager modules (all auto-imported)
    ├── fish.nix            # Fish shell config
    ├── git.nix             # Git configuration
    ├── home-config.nix     # Home-manager base settings
    ├── nvim.nix            # Neovim integration
    ├── opencode.nix        # Opencode tool
    ├── ssh-agent.nix       # SSH/keychain setup
    ├── starship.nix        # Starship prompt
    └── yazi.nix            # Yazi file manager
```

### Current Host Definition (flake.nix)

**Single host:** `nixosConfigurations.nixos`
- Hardcoded system: `x86_64-linux`
- All system-modules unconditionally imported
- All home-modules unconditionally imported for single user
- WSL configuration always enabled
- No flexibility for different machine types

### Key Problems Identified

1. **No multihost support** - only one host definition exists
2. **No conditional module loading** - all modules always active
3. **WSL hardcoded** - cannot easily support non-WSL hosts
4. **Single user assumption** - `const.nix` hardcodes one username
5. **Flat module structure** - no logical grouping by purpose/role
6. **All-or-nothing imports** - `import-modules.nix` loads everything from a directory

### What Works Well (Keep These)

✅ **`lib/import-modules.nix`** - Simple, effective auto-importer  
✅ **`lib/const.nix`** - Clear constants in one place  
✅ **Module simplicity** - Modules are straightforward, no over-abstraction  
✅ **Standard NixOS patterns** - Uses standard module options

---

## 3. Proposed Architecture

### Design Principles

1. **Roles define capabilities** - A role is a named collection of related functionality
2. **Hosts declare roles** - Each host specifies which roles it needs
3. **Modules check roles** - Modules activate only if their role is present
4. **Standard mechanisms only** - Use `specialArgs` + `lib.mkIf` (no custom magic)

### Role Categorization

Based on current modules, we define these initial roles:

| Role | Purpose | Modules Included |
|------|---------|------------------|
| `base` | Core system essentials | `core.nix`, `locale.nix`, `users.nix` |
| `cli-tools` | Command-line utilities | `packages.nix`, `shell.nix` |
| `wsl` | WSL-specific settings | `wsl.nix` |
| `development` | Developer tools | Parts of `packages.nix` (languages, dev tools) |
| `home-base` | Basic home-manager | `home-config.nix`, `git.nix`, `fish.nix`, `starship.nix` |
| `home-dev` | Development home tools | `nvim.nix`, `ssh-agent.nix`, `yazi.nix` |
| `home-extras` | Additional tools | `opencode.nix` |

### Directory Structure (Proposed)

```
nixos/
├── flake.nix                    # Multihost definitions with roles
├── hosts/                       # Per-host configuration
│   ├── nixos/                   # Current WSL host (backward compat)
│   │   └── default.nix         # Host-specific overrides (if needed)
│   └── README.md               # Host documentation template
├── lib/
│   ├── const.nix               # Global constants (shared across hosts)
│   ├── import-modules.nix      # (unchanged)
│   ├── mk-app.nix              # (unchanged)
│   └── mk-host.nix             # NEW: Host builder function
├── system-modules/
│   ├── base/                   # Role: base
│   │   ├── core.nix
│   │   ├── locale.nix
│   │   └── users.nix
│   ├── cli-tools/              # Role: cli-tools
│   │   ├── packages.nix
│   │   └── shell.nix
│   ├── wsl/                    # Role: wsl
│   │   └── wsl.nix
│   └── README.md               # Module organization docs
└── home-modules/
    ├── base/                   # Role: home-base
    │   ├── home-config.nix
    │   ├── git.nix
    │   ├── fish.nix
    │   └── starship.nix
    ├── dev/                    # Role: home-dev
    │   ├── nvim.nix
    │   ├── ssh-agent.nix
    │   └── yazi.nix
    ├── extras/                 # Role: home-extras
    │   └── opencode.nix
    └── README.md               # Module organization docs
```

---

## 4. Action Checklist

### Phase 1: Restructure Modules by Roles
- [ ] Create directory structure: `system-modules/{base,cli-tools,wsl}/`
- [ ] Move system modules into role directories
- [ ] Create directory structure: `home-modules/{base,dev,extras}/`
- [ ] Move home modules into role directories
- [ ] Add README.md files documenting role purposes

### Phase 2: Create Host Infrastructure
- [ ] Create `hosts/` directory
- [ ] Create `hosts/nixos/default.nix` for current host
- [ ] Create `hosts/README.md` with host creation template
- [ ] Create `lib/mk-host.nix` host builder function

### Phase 3: Update flake.nix for Multihost
- [ ] Define host registry with roles in `flake.nix`
- [ ] Update `nixosConfigurations` to use `mk-host.nix`
- [ ] Ensure backward compatibility (existing `nixos` host still works)

### Phase 4: Implement Role-Based Activation
- [ ] Update modules to check roles via `specialArgs`
- [ ] Test each module activates only when role is present
- [ ] Update `const.nix` to support per-host overrides

### Phase 5: Validation & Documentation
- [ ] Run `nix run ./nixos#nixos-ci` to validate system builds
- [ ] Test building the `nixos` host configuration
- [ ] Update README.md with multihost usage examples
- [ ] Document how to add new hosts

---

## 5. Execution Strategy & Implementation

### 5.1 Role-Based Module Activation Pattern

**Mechanism:** Pass `roles` list through `specialArgs`, modules check membership.

**Grounding Snippet - Module Pattern:**

```nix
# system-modules/wsl/wsl.nix
{ lib, const, roles, ... }:
{
  config = lib.mkIf (builtins.elem "wsl" roles) {
    wsl = {
      enable = true;
      defaultUser = const.user;
      useWindowsDriver = true;
    };
  };
}
```

**Key Points:**
- `roles` passed via `specialArgs` from `flake.nix`
- Standard `lib.mkIf` gates the entire config
- Simple `builtins.elem` check (no custom helpers needed)
- Module still declarative, just conditionally applied

### 5.2 Host Builder Function

**File:** `lib/mk-host.nix`

**Grounding Snippet:**

```nix
# lib/mk-host.nix
{ nixpkgs, home-manager, nixos-wsl }:
{
  name,
  system ? "x86_64-linux",
  roles ? [ ],
  hostConfig ? { },
  const,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  
  specialArgs = {
    inherit const roles;
  };

  modules = [
    # Import host-specific configuration
    (../hosts + "/${name}")
    
    # Import all system modules (they self-filter by roles)
    {
      imports = import ./import-modules.nix {
        inherit (nixpkgs) lib;
        dir = ../system-modules;
      };
    }
    
    # WSL module (if needed)
    (lib.mkIf (builtins.elem "wsl" roles) nixos-wsl.nixosModules.default)
    
    # Home Manager integration
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = { inherit const roles; };
        
        users.${const.user} = {
          imports = import ./import-modules.nix {
            inherit (nixpkgs) lib;
            dir = ../home-modules;
          };
        };
      };
    }
    
    # Merge any additional host-specific config
    hostConfig
  ];
}
```

**Key Points:**
- Simple function, no complex abstraction
- Takes `roles` list, passes through `specialArgs`
- Conditionally includes nixos-wsl based on roles
- Imports host directory by name convention
- All modules still imported, but self-filter

### 5.3 Updated flake.nix Structure

**Grounding Snippet:**

```nix
# flake.nix (outputs section)
outputs = { nixpkgs, nixos-wsl, home-manager, ... }:
let
  const = import ./lib/const.nix;
  systems = [ "x86_64-linux" ];
  
  # Host builder
  mkHost = import ./lib/mk-host.nix {
    inherit nixpkgs home-manager nixos-wsl;
  };
  
  # Host registry - Single source of truth
  hosts = {
    nixos = {
      roles = [ "base" "cli-tools" "wsl" "home-base" "home-dev" "home-extras" ];
      # system = "x86_64-linux";  # optional, defaults to x86_64-linux
      # hostConfig = { };          # optional overrides
    };
    
    # Example future host (commented out for now):
    # laptop = {
    #   roles = [ "base" "cli-tools" "desktop" "home-base" "home-dev" ];
    # };
  };
  
  # Build all hosts
  buildHost = name: config:
    mkHost ({
      inherit name const;
    } // config);
    
in {
  nixosConfigurations = nixpkgs.lib.mapAttrs buildHost hosts;
  
  # ... rest of outputs (formatter, apps, etc.)
}
```

**Key Points:**
- `hosts` attrset is the single source of truth
- Each host just lists its roles
- `mapAttrs` builds all hosts automatically
- Adding new host = add entry to `hosts` attrset
- Clean, readable, no "magic"

### 5.4 Per-Host Configuration

**File:** `hosts/nixos/default.nix`

**Grounding Snippet:**

```nix
# hosts/nixos/default.nix
{ const, ... }:
{
  # Host-specific overrides go here
  # Most hosts won't need anything here - roles handle it
  
  networking.hostName = "nixos";
  
  # Example: Override timezone for this specific host
  # time.timeZone = "America/New_York";
}
```

**Key Points:**
- Minimal - most config comes from roles
- Use only for truly host-specific settings
- Networking hostname is a good example
- Empty file is valid (roles do everything)

### 5.5 Migration Strategy (Backward Compatibility)

**Step 1:** Restructure modules into role directories  
**Step 2:** Create `hosts/nixos/default.nix` (minimal)  
**Step 3:** Create `lib/mk-host.nix`  
**Step 4:** Update `flake.nix` with new structure  
**Step 5:** Verify `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`

**Critical:** The existing `nixos` host continues to work identically. All modules are assigned to roles it has, so behavior is unchanged.

### 5.6 Testing Approach

1. **Before restructure:** Build current system
   ```bash
   nix build .#nixosConfigurations.nixos.config.system.build.toplevel
   ```

2. **After each phase:** Verify build still succeeds

3. **Role filtering test:** Temporarily remove a role, verify related modules don't activate

4. **CI validation:** Run existing CI
   ```bash
   nix run ./nixos#nixos-ci
   ```

---

## 6. Implementation Notes

### What NOT to Do

❌ **Don't create complex helper functions** - `lib.mkIf` + `builtins.elem` is enough  
❌ **Don't deep-nest directories** - 2 levels max (role-dir/module.nix)  
❌ **Don't add custom module options** unless truly needed  
❌ **Don't abstract the host builder** into a framework  
❌ **Don't change module behavior** - only change when/if they activate

### Simplicity Checks

Before implementing any helper function, ask:
1. Can this be done with standard `lib` functions?
2. Does this require reading >2 files to understand?
3. Is this "clever" or "clear"?

If answers are yes/yes/clever → reject the approach.

### File Organization Rationale

**Why role-based directories?**
- Logical grouping: Related modules together
- Easy to understand: "What does the `wsl` role include?" → Look in `system-modules/wsl/`
- Scales well: New role = new directory

**Why not use NixOS module options for roles?**
- Over-engineering: `specialArgs` + `mkIf` is simpler
- Standard pattern: No custom conventions to learn
- Clear data flow: Roles defined in flake, checked in modules

---

## 7. Future Enhancements (Out of Current Scope)

- **Per-user home configurations:** Support multiple users per host
- **Role validation:** Ensure role dependencies (e.g., `desktop` requires `base`)
- **Role composition:** Meta-roles that bundle other roles
- **Deployment integration:** colmena/deploy-rs configuration
- **Hardware profiles:** Separate hardware-specific config from roles

These can be added later using the same simple patterns, if needed.

---

## 8. Success Validation

After implementation, verify:

1. ✅ Build existing `nixos` host → succeeds with identical output
2. ✅ Define a new test host with different roles → builds successfully
3. ✅ Remove a role from a host → related modules don't activate
4. ✅ CI passes: `nix run ./nixos#nixos-ci`
5. ✅ Documentation clear: New contributor can add a host in <5 minutes

---

## Conclusion

This refactor transforms a single-host configuration into a multihost setup using the **Roles & Profiles** pattern, while maintaining the philosophy of "Worse is Better."

**Core mechanism:** Hosts declare roles in `flake.nix` → roles passed via `specialArgs` → modules conditionally activate with `lib.mkIf`.

**No magic.** No complex abstractions. Just standard NixOS, organized sensibly.

The implementation plan is actionable, with concrete code examples showing exactly how each piece works. A new host is defined by adding 3 lines to `flake.nix` and creating a minimal `hosts/<name>/default.nix`.

Simple. Effective. Maintainable.
