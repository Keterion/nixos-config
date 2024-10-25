{ lib, pkgs, config, ...}:
{
  options.modules.apps.games.epicgames = {
    enable = lib.mkEnableOption "heroic launcher for epicgames games";
  };
  config = lib.mkIf config.modules.apps.games.epicgames.enable {
    home-manager.users.${config.vars.globals.defaultUser.name} = {
      home.packages = [
        pkgs.heroic
      ];
    };
  };
}
