{ lib, pkgs, config, ... }:
let
  cfg = config.apps.games.epicgames;
in {
  options.apps.games.epicgames.enable = lib.mkEnableOption "epicgames using heroiclauncher";

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.heroic ];
  };
}
