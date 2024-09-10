{ lib, config, ... }:
with lib;
{
  options.vars.theming = {
    colorscheme = mkOption {
      default = "tokyonight-moon";
      type = types.enum["tokyonight-moon" "catppuccin-mocha" "gruvbox-dark"];
      description = "Which colors to use for the system";
    };
    colors = {
      fg = mkOption {
	type = types.str;
      };
      fg_dark = mkOption {
	type = types.str;
      };
      bg = mkOption {
	type = types.str;
      };
      bg_dark = mkOption {
	type = types.str;
      };
      blue1 = mkOption {
	type = types.str;
      };
      blue2 = mkOption {
	type = types.str;
      };
      blue3 = mkOption {
	type = types.str;
      };
      cyan = mkOption {
	type = types.str;
      };
      green = mkOption {
	type = types.str;
      };
      magenta = mkOption {
	type = types.str;
      };
      orange = mkOption {
	type = types.str;
      };
      purple = mkOption {
	type = types.str;
      };
      red1 = mkOption {
	type = types.str;
      };
      red2 = mkOption {
	type = types.str;
      };
      teal = mkOption {
	type = types.str;
      };
      yellow = mkOption {
	type = types.str;
      };
    };
  };

  config.vars.theming.colors = import ./colorschemes/${config.vars.theming.colorscheme}.nix;
}
