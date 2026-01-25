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
    home-manager.users.${config.sys.users.default.name}.programs.rofi = {
      enable = true;
      modes = ["games"];
      plugins = with pkgs; [
        rofi-games
      ];
    };
  };
}
