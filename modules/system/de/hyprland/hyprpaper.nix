{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  wp_conf = osConfig.sys.de.hyprland.wallpaper;
in {
  services.hyprpaper = lib.mkIf wp_conf.enable {
    enable = true;
    settings =
      {
        ipc = "on";
        splash = false;
      }
      // lib.mkIf (!wp_conf.wallhaven.enable) {
        preload = ["~/Pictures/wallpaper.png"];
        wallpaper = [
          {
            monitor = "";
            path = "${wp_conf.path}";
          }
        ];
      };
  };
  #services.awww.enable = osConfig.sys.de.hyprland.wallpaper.enable;
  #wayland.windowManager.hyprland.settings.exec-once = [
  #  "${pkgs.awww}/bin/awww img ${osConfig.sys.de.hyprland.wallpaper.path}"
  #];
}
#// lib.mkIf osConfig.system.de.hyprland.hyprpaper.wallhaven.enable {
#wayland.windowManager.hyprland.settings.exec-once = let
#  user_path = "/home/${osConfig.system.users.default.name}";
#in [
#  "top_wallpaper & ${pkgs.imagemagick}/bin/magick ${user_path}/Pictures/wallhaven.png ${user_path}/Pictures/wallhaven_wallpaper.png & rm ${user_path}/Pictures/wallhaven.png & hyprctl hyprpaper reload ,'${user_path}/Pictures/wallhaven_wallpaper.png'"
#];
#}

