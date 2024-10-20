{ pkgs, config, lib, ... }:
let
  cfg = config.modules.apps.games;
in
{
  options.modules.apps.games.osu = {
    enable = lib.mkEnableOption "the osu! game";
  };

  config = lib.mkIf cfg.osu.enable {
    home-manager.users.${config.vars.globals.defaultUser.name}.home.packages = [ pkgs.osu-lazer-bin ];
  };
}
    
