{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  services.hyprpaper = lib.mkIf osConfig.system.de.hyprland.hyprpaper.enable {
    enable = true;
    settings =
      {
        ipc = "on";
        splash = false;
      }
      // lib.mkIf (!osConfig.system.de.hyprland.hyprpaper.wallhaven.enable) {
        preload = ["~/Pictures/wallpaper.png"];
        wallpaper = [",~/Pictures/wallpaper.png"];
      };
  };
}
// lib.mkIf osConfig.system.de.hyprland.hyprpaper.wallhaven.enable {
  osConfig.scripts.api.wallhaven.enable = true;
  wayland.windowManager.hyprland.settings.exec-once = let
    user_path = "/home/${osConfig.system.users.default.name}";
  in [
    "top_wallpaper & ${pkgs.imagemagick}/bin/magick ${user_path}/Pictures/wallhaven.png ${user_path}/Pictures/wallhaven_wallpaper.png & rm ${user_path}/Pictures/wallhaven.png & hyprctl hyprpaper reload ,'${user_path}/Pictures/wallhaven_wallpaper.png'"
  ];
}
