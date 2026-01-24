{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.sys.security.secureboot;
in {
  options.sys.security.secureboot = {
    setup = {
      utils = lib.mkEnableOption "Lanzaboote setup utils";
      done = lib.mkEnableOption "ONLY SET TO TRUE IF THE SETUP AS PER https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/prepare-your-system.md HAS BEEN COMPLETED";
    };
    enable = lib.mkEnableOption "Secure boot using lanzaboote, follow https://github.com/nix-community/lanzaboote/tree/master/docs/getting-started";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.enable && !cfg.setup.done);
          message = ''
            Secure Boot is enabled but setup.done is false.
            Complete the sbctl/lanzaboote setup first:
            https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/prepare-your-system.md
          '';
        }
      ];
    }
    (lib.mkIf cfg.setup.utils {
      environment.systemPackages = [
        pkgs.sbctl
      ];
    })
    (lib.mkIf cfg.enable
      {
        boot = {
          loader.systemd-boot.enable = lib.mkForce false;
          lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
        };
      })
  ];
}
