{ lib, pkgs, config, ...}: {
  options.modules.apps.office.enable = lib.mkEnableOption "libreoffice suite";
  config = lib.mkIf config.modules.apps.office.enable {
    home-manager.users.${config.vars.globals.defaultUser.name} = {
      home.packages = [
        pkgs.stable.libreoffice
      ];
    };
  };
}
