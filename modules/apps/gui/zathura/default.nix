{ lib, pkgs, config, ... }:
let
  cfg = config.apps.zathura;
in {
  options.apps.zathura.enable = lib.mkOption {
    default = config.apps.modules.gui.media.enable;
    type = lib.types.bool;
    description = "Whether to enable zathura.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.zathura
    ];
  };
}
