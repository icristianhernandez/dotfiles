{
  guardRole,
  pkgs,
  lib,
  ...
}:

# Mitigates nixpkgs#126590: KDE Plasma launches scan thousands of
# /nix/store paths in XDG_DATA_DIRS, producing tens of thousands of stat()
# syscalls. We collapse that list into a single lndir-mirrored store path
# for plasma-workspace's wrapper.
#
# Scope: kdePackages.plasma-workspace only. plasmashell is the most-launched
# Plasma binary and inherits the deepest closure, so flattening there yields
# the largest perceived win per rebuild minute.
#
# To extend to other laggy targets (plasma-desktop, systemsettings, kwin, ...):
# add the same `overrideAttrs { preFixup = ...; }` block in the inner
# overrideScope, targeting the wanted kdePackages.<x>. xdgdataPkg is reusable
# across them.
#
# Trade-off of extending: each added package pays its own rebuild on every
# bump (~10-30 min on this laptop). Widen only if the lag remains
# perceptible after the initial deployment.
guardRole "plasma" {
  nixpkgs.overlays = [
    (_kdeFinal: kdePrev: {
      kdePackages = kdePrev.kdePackages.overrideScope (
        _kdeFinal': kdePrev': {
          plasma-workspace =
            let
              basePkg = kdePrev'.plasma-workspace;
              xdgdataPkg = pkgs.stdenv.mkDerivation {
                name = "${basePkg.name}-xdgdata";
                buildInputs = [ basePkg ];
                dontUnpack = true;
                dontFixup = true;
                dontWrapQtApps = true;
                installPhase = ''
                  mkdir -p $out/share
                  ( IFS=:
                    for DIR in $XDG_DATA_DIRS; do
                      if [[ -d "$DIR" ]]; then
                        ${lib.getExe pkgs.lndir} -silent "$DIR" $out
                      fi
                    done
                  )
                '';
              };
              derivedPkg = basePkg.overrideAttrs {
                preFixup = ''
                  for index in "''${!qtWrapperArgs[@]}"; do
                    if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] \
                       && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                      unset -v "qtWrapperArgs[$((index+0))]"
                      unset -v "qtWrapperArgs[$((index+1))]"
                      unset -v "qtWrapperArgs[$((index+2))]"
                      unset -v "qtWrapperArgs[$((index+3))]"
                    fi
                  done
                  qtWrapperArgs=("''${qtWrapperArgs[@]}")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                '';
              };
            in
            derivedPkg;
        }
      );
    })
  ];
}
