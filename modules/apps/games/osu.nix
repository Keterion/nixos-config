{ pkgs, config, lib, ... }:
let
  cfg = modules.apps.games;
in
{
  options.modules.apps.games.osu.enable = lib.mkEnableOption "the osu! game";

  config = lib.mkIf cfg.osu.enable {
    home-manager.users."etherion".home.packages = [ pkgs.unstable.osu-lazer-bin ];
  }
}
    
