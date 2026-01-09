{
  lib,
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  home.packages = with pkgs; [ prismlauncher ];

  home.activation.prismLauncherBypass = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.local/share/PrismLauncher
    $DRY_RUN_CMD cat > ~/.local/share/PrismLauncher/accounts.json << 'EOF'
    {
      "accounts": [
          {
              "entitlement": {
                  "canPlayMinecraft": true,
                  "ownsMinecraft": true
              },
              "msa-client-id": "",
              "type": "MSA"
          },
          {
              "active": true,
              "profile": {
                  "capes": [
                  ],
                  "id": "dd84d8a449a03219b321b3b69c83450b",
                  "name": "slaski",
                  "skin": {
                      "id": "",
                      "url": "",
                      "variant": ""
                  }
              },
              "type": "Offline",
              "ygg": {
                  "extra": {
                      "clientToken": "dc8bc8e1670d47b28306dc4912f853b3",
                      "userName": "slaski"
                  },
                  "iat": 1767725347,
                  "token": "0"
              }
          }
      ],
      "formatVersion": 3
    }
    EOF
  '';
}
