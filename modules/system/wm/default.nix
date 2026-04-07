{config, ...}: {
  config = {
    services.xserver.xkb = {
      inherit (config.sys.keyboard) layout variant;
    };
    #home-manager.users.${config.sys.users.default.name}.wayland.windowManager.hyprland.settings.input = {
    #  kb_layout = config.sys.keyboard.layout;
    #  kb_variant = config.sys.keyboard.variant;
    #};
  };
}
