{ lib, pkgs, config, ...}:
{
  options.modules.games.lutris = {
    enable = lib.mkEnableOption "the lutris game launcher";
  };
  config = lib.mkIf config.modules.games.luris.enable {
    home-manager.users.${config.vars.globals.defaultUser.name} = {
      home.packages = [
        pkgs.lutris
      ];
    };
  };
}
