{
  config,
  pkgs,
  ...
}: {
  services.awww = {
    enable = true;
    #extraArgs = {};
  };
  wayland.windowManager.hyprland.settings.on._args = [
    "hyprland.start"
    "hl.exec_cmd(${pkgs.awww}/bin/awww img ${config.sys.de.hyprland.wallpaper.path})"
  ];
}
