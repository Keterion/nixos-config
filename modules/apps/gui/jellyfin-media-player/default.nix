{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.jellyfin-media-player;
in {
  options.apps.jellyfin-media-player.enable = lib.mkOption {
    default = config.apps.modules.gui.media.enable;
    type = lib.types.bool;
    description = "Whether to enable jellyfin media player.";
  };
  config = builtins.trace "jellyfin-media-player permits an unsecure package" lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = ["qtwebengine-5.15.19"];
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.stable.jellyfin-media-player
    ];
  };
}
