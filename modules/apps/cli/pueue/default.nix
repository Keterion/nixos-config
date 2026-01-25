{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.pueue;
in {
  options.apps.pueue = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
      description = "Whether to enable pueue.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.sys.users.default.name} = {
      services.pueue = {
        enable = true;
      };
    };
    environment.systemPackages = [pkgs.pueue];
  };
}
