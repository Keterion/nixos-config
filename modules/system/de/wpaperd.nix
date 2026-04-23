{config, ...}: {
  # We are in home-manager.users.<name>
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        inherit (config.sys.de.hyprland.wallpaper) path;
        mode = "center";
        initial-transition = true;
      };
    };
  };
}
