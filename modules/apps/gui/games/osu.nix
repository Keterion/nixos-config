{ pkgs, config, lib, ... }:
let
  cfg = config.apps.games.osu;
in {
  options.apps.games.osu.enable = lib.mkEnableOption "the osu! game";

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.osu-lazer-bin ];
  };
}
