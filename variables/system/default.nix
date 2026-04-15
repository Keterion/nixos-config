{
  config,
  lib,
  ...
}: {
  imports = [
    ./users
    ./colors
    #    ./fonts
  ];
  options.sys = {
    configDir = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos;
      example = /home/john/nixos;
    };
    keyboard = {
      qwerty_dv = lib.mkEnableOption "Both standard qwerty as well as dvorak";
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Keyboard layout, or multiple layouts separated by commas";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Keyboard variant";
        example = "colemak";
      };
    };
  };
  config = {
    console.keyMap = config.sys.keyboard.layout;
  };
}
