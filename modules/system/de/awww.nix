{
  config,
  pkgs,
  ...
}: {
  services.awww = {
    enable = true;
    #extraArgs = {};
  };
  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.awww}/bin/awww img ${config.sys.de.hyprland.wallpaper.path}"
  ];
}
