{ lib, pkgs, config, ... }:
let
  cfg = config.apps.gimp;
in {
  options.apps.gimp.enable = lib.mkOption {
    default = config.apps.modules.gui.art.dd.enable;
    type = lib.types.bool;
    description = "Whether to enable gimp3.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.gimp3
    ];
  };
}
