{ lib, pkgs, osConfig, config, ...}:
let
  cfg = config.modules.apps;
in
{
  options.modules.apps.cava.enable = lib.mkEnableOption "the audio visualizer cava";

  config = lib.mkIf cfg.cava.enable {
    programs.cava = {
      enable = cfg.cava.enable;
      settings = {
	general = {
	  framerate = 60;

	  autosens = 1;
	  overshoot = 20;

	  sensitivity = 100;

	  bars = 0; # autofill bars based on terminal
	};
	input = {
	  method = "alsa";
	  source = "auto";
	};
	output = {
	  
	};
	color = with osConfig.vars.theming; {
	  gradient = 1;
	  gradient_color_1 = "#${colors.red1}";
	  gradient_color_2 = "#${colors.yellow}";
	  gradient_color_3 = "#${colors.green}";
	  gradient_color_4 = "#${colors.teal}";
	  gradient_color_5 = "#${colors.cyan}";
	  gradient_color_6 = "#${colors.blue1}";
	  gradient_color_7 = "#${colors.purple}";
	  gradient_color_8 = "#${colors.magenta}";
	};
	smoothing = {
	  
	};
      };
    };
  };
}
