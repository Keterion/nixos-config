{ lib, config, ... }:
let
  cfg = config.apps.cava;
in {
  options.apps.cava.enable = lib.mkOption {
    default = config.apps.modules.all.enable;
    type = lib.types.bool;
    description = "Whether to enable the music visualizer cava.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.cava = {
      enable = true;
      settings = {
	general = {
	  framerate = 60;

	  autosens = 1;
	  overshoot = 20;

	  sensitivity = 100;

	  bars = 0; # autofill
	};
	input = {
	  source = "auto";
	};
	color = with config.system; {
	  gradient = 1;
	  gradient_color_1 = "'#${colors.red1}'";
	  gradient_color_2 = "'#${colors.yellow}'";
	  gradient_color_3 = "'#${colors.green}'";
	  gradient_color_4 = "'#${colors.teal}'";
	  gradient_color_5 = "'#${colors.cyan}'";
	  gradient_color_6 = "'#${colors.blue1}'";
	  gradient_color_7 = "'#${colors.purple}'";
	  gradient_color_8 = "'#${colors.magenta}'";
	};
      };
    };
  };
}
