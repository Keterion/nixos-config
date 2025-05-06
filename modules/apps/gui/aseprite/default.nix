{ lib, pkgs, config, ... }:
let
  cfg = config.apps.aseprite;
in {
  options.apps.aseprite.enable = lib.mkOption {
    default = config.apps.modules.gui.art.dd.enable;
    type = lib.types.bool;
    description = "Whether to enable aseprite.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.aseprite
    ];
  };
}
