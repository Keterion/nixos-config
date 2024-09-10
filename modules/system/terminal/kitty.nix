{ lib, pkgs, config, ...}:
with lib;
let
  cfg = config.modules.system.terminal;
in {
  options.modules.system.terminal = {
    kitty.enable = mkEnableOption "the Kitty terminal";
  };

  config = {
    home-manager.users."etherion" = {
      programs.kitty = mkIf cfg.kitty.enable {
        enable = true;
        keybindings = {
          "ctrl+shift+j" = "launch --location=hsplit --cwd=current";
          "ctrl+shift+l" = "launch --location=vsplit --cwd=current";

          "ctrl+h" = "neighboring_window left";
          "ctrl+l" = "neighboring_window right";
          "ctrl+k" = "neighboring_window up";
          "ctrl+j" = "neighboring_window down";

          "shift+up" = "move_window up";
          "shift+down" = "move_window down";
          "shift+left" = "move_window left";
          "shift+right" = "move_window right";

          "ctrl+shift+up" = "layout_action move_to_screen_edge top";
          "ctrl+shift+down" = "layout_action move_to_screen_edge bottom";
          "ctrl+shift+left" = "layout_action move_to_screen_edge left";
          "ctrl+shift+rigt" = "layout_action move_to_screen_edge right";

          "ctrl+shift+[" = "previous_tab";
          "ctrl+shift+]" = "next_tab";
        };
        settings = with config.vars.theming; {
          enable_audio_bell = false;

          draw_minimal_borders = true;
          window_margin_width = 1;
          window_padding_width = 2;

          inactive_text_alpha = "0.8";

          tab_bar_style = "slant";
          tab_bar_align = "center";
          tab_bar_min_tabs = 1;
          tab_activity_symbol = "!";

	  enabled_layouts = "splits:split_axis=splits";

	  # THEMING
	  background = "#${colors.bg}";
	  foreground = "#${colors.fg}";
	  selection_background = "#${colors.bg_dark}";
	  selection_foreground = "#${colors.fg}";

	  #url_color
	  cursor = "#${colors.fg}";
	  cursor_text_color = "#${colors.bg}";

	  active_tab_background = "#${colors.bg}";
	  active_tab_foreground = "#${colors.fg}";
	  inactive_tab_background = "#${colors.bg_dark}";
	  inactive_tab_foreground = "#${colors.fg_dark}";

	  active_border_color = "#${colors.blue1}";
	  inactive_border_color = "#${colors.bg}";

	  #black
	  color0 = "#${colors.bg_dark}";
	  color8 = "#${colors.bg}";

	  #Red
	  color1 = "#${colors.red2}";
	  color9 = "#${colors.red1}";

	  #Green
	  color2 = "#${colors.green}";
	  color10 = "#${colors.green}";

	  #Yellow
	  color3 = "#${colors.yellow}";
	  color11 = "#${colors.yellow}";

	  #Blue
	  color4 = "#${colors.blue2}";
	  color12 = "#${colors.blue1}";

	  #Magenta
	  color5 = "#${colors.magenta}";
	  color13 = "#${colors.magenta}";

	  #Cyan
	  color6 = "#${colors.cyan}";
	  color14 = "#${colors.cyan}";

	  #White
	  color7 = "#${colors.fg_dark}";
	  color15 = "#${colors.fg}";
        };
      };
    };
  };
}
