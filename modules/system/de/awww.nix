{
  config,
  lib,
  ...
}: {
  services.awww = {
    enable = true;
    extraArgs = {};
  };
  wayland.windowManager.hyprland.settings.exec-once = [
    "awww img ${config.sys.de.hyprland.wallpaper.path}"
  ];
}
