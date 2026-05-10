{
  pkgs,
  mkApp,
  dotfilesDir,
  ...
}:
let
  script =
    let
      helpers = import ./helpers.nix { inherit pkgs dotfilesDir; };
    in
    pkgs.writeShellApplication {
      name = "ci";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.nix
        pkgs.git
      ];
      text = ''
        ${helpers.prelude {
          name = "ci";
          withNix = true;
          appPrefixAttr = false;
        }}

        mode="changed"
        while [ "$#" -gt 0 ]; do
          case "$1" in
            --apply-even-without-changes)
              mode="all"
              ;;
            --help)
              echo "usage: ci [--apply-even-without-changes]"
              exit 0
              ;;
            *)
              log "unknown argument: $1"
              echo "usage: ci [--apply-even-without-changes]"
              exit 2
              ;;
          esac
          shift
        done

        check_changes() {
          local dir="$1"
          cd "$REPO_ROOT" || return 1
          if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            return 0
          fi

          if [ -n "$(git status --porcelain "$dir")" ]; then
            return 0
          fi

          base_branch="origin/main"
          if ! git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
            base_branch="main"
          fi
          if ! git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
            base_branch="master"
          fi

          if git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
            if [ -n "$(git diff --name-only "$(git merge-base HEAD "$base_branch")" -- "$dir")" ]; then
              return 0
            fi
          fi

          return 1
        }

        declare -A RESULTS
        declare -A STATUS
        ALL_DOMAINS_RAN="yes"

        run_subci() {
          local name="$1"; shift
          local domain_dir="$1"
          local rc=0
          local tmp_log

          if [ "$mode" = "changed" ] && ! check_changes "$domain_dir"; then
            STATUS["$name"]="SKIPPED"
            RESULTS["$name"]="no changes detected in $domain_dir"
            ALL_DOMAINS_RAN="no"
            return 0
          fi

          tmp_log="$(mktemp)"
          if "''${NIX_RUN[@]}" "''${APP_PREFIX}$name" >"$tmp_log" 2>&1; then
            STATUS["$name"]="PASSED"
            RESULTS["$name"]="completed successfully"
          else
            rc=$?
            STATUS["$name"]="FAILED"
            RESULTS["$name"]="failed (scope: $domain_dir)"
            log "$name failed (exit $rc)"
            cat "$tmp_log" >&2
          fi
          rm -f "$tmp_log"
        }

        run_subci "nixos-ci" "${helpers.paths.nixosDir}"
        run_subci "nvim-ci" "${helpers.paths.nvimCfgDir}"
        run_subci "workflows-ci" "${helpers.paths.workflowsDir}"

        echo "ci report"
        echo "all_domains_ran: $ALL_DOMAINS_RAN"
        EXIT_CODE=0
        for name in "nixos-ci" "nvim-ci" "workflows-ci"; do
          printf "%s: %s - %s\n" "$name" "''${STATUS[$name]}" "''${RESULTS[$name]}"
          if [ "''${STATUS[$name]}" = "FAILED" ]; then
            EXIT_CODE=1
          fi
        done

        echo "result: $([ "$EXIT_CODE" -eq 0 ] && echo "ok" || echo "failed")"
        exit $EXIT_CODE
      '';
    };

in
mkApp {
  program = "${script}/bin/ci";
  meta = {
    description = "Run nixos-ci, nvim-ci, workflows-ci in order (with logging)";
  };
}
