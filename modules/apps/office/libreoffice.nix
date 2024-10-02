{ lib, pkgs, config, ...}: {
  options.modules.apps.office.enable = lib.mkEnableOption "libreoffice suite";
  config = lib.mkIf config.modules.apps.office.enable {
    home-manager.users."etherion" = {
      home.packages = [
        pkgs.stable.libreoffice
      ];
    };
  };
}
