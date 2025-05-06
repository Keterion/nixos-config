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
  options.system = {
    configDir = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos;
      example = /home/john/nixos;
    };
    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
        default = "us";
        description = "Keyboard layout, or multiple layouts separated by commas";
      };
      variant = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Keyboard variant";
        example = "colemak";
      };
    };
  };
}
