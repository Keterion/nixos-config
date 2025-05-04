{ lib, pkgs, config, ... }:
let
  cfg = config.apps.obs;
in {
  options.apps.obs.enable = lib.mkOption {
    default = config.apps.modules.gui.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable obs.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.obs-studio
    ];
  };
}
