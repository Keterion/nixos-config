{ lib, config, pkgs, ... }:
let
  cfg = config.apps.libreoffice;
in {
  options.apps.libreoffice.enable = lib.mkEnableOption "libreoffice suite";
  
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.stable.libreoffice
    ];
  };
}
