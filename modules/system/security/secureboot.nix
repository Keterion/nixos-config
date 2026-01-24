{
  lib,
  pkgs,
  config,
}: let
  cfg = config.system.security.secureboot;
in {
  options.system.security.secureboot = {
    setup = {
      utils = lib.mkEnableOption "Lanzaboote setup utils";
      done = lib.mkEnableOption "ONLY SET TO TRUE IF THE SETUP AS PER https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/prepare-your-system.md HAS BEEN COMPLETED";
    };
    enable = lib.mkEnableOption "Secure boot using lanzaboote, follow https://github.com/nix-community/lanzaboote/tree/master/docs/getting-started";
  };

  config =
    {
      environment.systemPackages = with pkgs;
        lib.optionals cfg.setup.utils [
          sbctl
        ];
    }
    // (
      if cfg.enable
      then {
        boot =
          if cfg.setup.done
          then {
            loader.systemd-boot.enable = lib.mkForce false;
            lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          }
          else builtins.abort "You need to finish setup and set setup.done to true before enabling secureboot";
      }
      else {}
    );
}
