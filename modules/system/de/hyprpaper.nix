{
  config,
  lib,
  pkgs,
  ...
}: let
  wp_conf =
    config.sys.de.hyprland.wallpaper;
in {
  services.hyprpaper = {
    enable = true;
    settings =
      {
        ipc = "on";
        splash = false;
      }
      // lib.mkIf (!wp_conf.wallhaven.enable) {
        preload = [wp_conf.path];
        wallpaper = [
          {
            monitor = "";
            path = "${wp_conf.path}";
          }
        ];
      };
  };
}
