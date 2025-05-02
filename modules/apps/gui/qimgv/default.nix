{ lib, pkgs, config, ... }:
let
  cfg = config.apps.qimgv;
in {
  options.apps.qimgv.enable = lib.mkOption {
    default = config.apps.modules.gui.media.enable;
    type = lib.types.bool;
    description = "Whether to enable qimgv.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.qimgv
    ];
  };
}
