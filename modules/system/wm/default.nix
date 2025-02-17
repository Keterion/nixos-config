{ config, ... }: {
  config = {
    services.xserver.xkb = {
      layout = config.system.keyboard.layout;
      variant = config.system.keyboard.variant;
    };
    home-manager.users.${config.system.users.default.name}.wayland.windowManager.hyprland.settings.input = {
      kb_layout = config.system.keyboard.layout;
      kb_variant = config.system.keyboard.variant;
    };
  };
}
