{config, ...}: {
  config = {
    services.xserver.xkb = {
      layout = config.sys.keyboard.layout;
      variant = config.sys.keyboard.variant;
    };
    home-manager.users.${config.sys.users.default.name}.wayland.windowManager.hyprland.settings.input = {
      kb_layout = config.sys.keyboard.layout;
      kb_variant = config.sys.keyboard.variant;
    };
  };
}
