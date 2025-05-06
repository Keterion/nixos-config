{ lib, pkgs, config, ... }:
let
  cfg = config.apps.jellyfin-media-player;
in {
  options.apps.jellyfin-media-player.enable = lib.mkOption {
    default = config.apps.modules.gui.media.enable;
    type = lib.types.bool;
    description = "Whether to enable jellyfin media player.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.jellyfin-media-player
    ];
  };
}
