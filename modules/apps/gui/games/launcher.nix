{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.games.launcher;
in {
  options.apps.games.launcher = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.games.enable;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-games
      ];
    };
  };
}
