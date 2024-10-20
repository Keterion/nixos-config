{ lib, pkgs, config, ...}:
{
  options.modules.apps.games.lutris = {
    enable = lib.mkEnableOption "the lutris game launcher";
  };
  config = lib.mkIf config.modules.apps.games.lutris.enable {
    home-manager.users.${config.vars.globals.defaultUser.name} = {
      home.packages = [
        pkgs.lutris
      ];
    };
  };
}
