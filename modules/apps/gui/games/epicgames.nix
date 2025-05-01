{ lib, pkgs, config, ... }:
let
  cfg = config.apps.games.epicgames;
in {
  options.apps.games.epicgames.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable epicgames via heroic launcher";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.heroic ];
  };
}
