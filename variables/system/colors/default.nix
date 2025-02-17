{ config, lib, ... }: {
  options.system = {
    colorscheme = lib.mkOption {
      default = "tokyonight-moon";
      type = lib.types.enum["tokyonight-moon" "catppuccin-mocha" "gruvbox-dark"];
      description = "Which colorscheme to use for the system";
    };
    colors = {
      fg = lib.mkOption {
        type = lib.types.str;
      };
      fg_dark = lib.mkOption {
        type = lib.types.str;
      };
      bg = lib.mkOption {
        type = lib.types.str;
      };
      bg_dark = lib.mkOption {
        type = lib.types.str;
      };
      blue1 = lib.mkOption {
        type = lib.types.str;
      };
      blue2 = lib.mkOption {
        type = lib.types.str;
      };
      blue3 = lib.mkOption {
        type = lib.types.str;
      };
      cyan = lib.mkOption {
        type = lib.types.str;
      };
      green = lib.mkOption {
        type = lib.types.str;
      };
      magenta = lib.mkOption {
        type = lib.types.str;
      };
      orange = lib.mkOption {
        type = lib.types.str;
      };
      purple = lib.mkOption {
        type = lib.types.str;
      };
      red1 = lib.mkOption {
        type = lib.types.str;
      };
      red2 = lib.mkOption {
        type = lib.types.str;
      };
      teal = lib.mkOption {
        type = lib.types.str;
      };
      yellow = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config.system.colors = import ./${config.system.colorscheme}.nix;
}
