{ lib, config, pkgs, ... }:
let
  cfg = config.apps.libreoffice;
in {
  options.apps.libreoffice.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable the libreoffice suite.";
  };  
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.stable.libreoffice
    ];
  };
}
