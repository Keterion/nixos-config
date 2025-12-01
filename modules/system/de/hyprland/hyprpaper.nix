{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  #services.hyprpaper = lib.mkIf osConfig.system.de.hyprland.wallpaper.enable {
  #  enable = true;
  #  settings =
  #    {
  #      ipc = "on";
  #      splash = false;
  #    }
  #    // lib.mkIf (!osConfig.system.de.hyprland.hyprpaper.wallhaven.enable) {
  #      preload = ["~/Pictures/wallpaper.png"];
  #      wallpaper = [",~/Pictures/wallpaper.png"];
  #    };
  #};
  services.swww.enable = osConfig.system.de.hyprland.wallpaper.enable;
  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.swww}/bin/swww img ${osConfig.system.de.hyprland.wallpaper.path}"
  ];
}
#// lib.mkIf osConfig.system.de.hyprland.hyprpaper.wallhaven.enable {
#wayland.windowManager.hyprland.settings.exec-once = let
#  user_path = "/home/${osConfig.system.users.default.name}";
#in [
#  "top_wallpaper & ${pkgs.imagemagick}/bin/magick ${user_path}/Pictures/wallhaven.png ${user_path}/Pictures/wallhaven_wallpaper.png & rm ${user_path}/Pictures/wallhaven.png & hyprctl hyprpaper reload ,'${user_path}/Pictures/wallhaven_wallpaper.png'"
#];
#}

