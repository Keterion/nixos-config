{ pkgs, config, lib, ... }:
let
  cfg = config.apps.games.osu;
in {
  options.apps.games.osu.enable = lib.mkOption {
    default = config.apps.modules.gui.games.enable;
    type = lib.types.bool;
    description = "Whether to enable osu.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.osu-lazer-bin ];
  };
}
