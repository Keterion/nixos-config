{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.system.terminal.kitty;
in {
  options.system.terminal.kitty = {
    enable = lib.mkEnableOption "the kitty terminal";
    default = lib.mkEnableOption "kitty as default terminal";
    remoteControl = lib.mkEnableOption "remote control for kitty";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
    ];
    environment.variables =
      lib.mkIf cfg.default
      {
        TERM = "kitty";
        TERMINAL = "kitty";
      };
    home-manager.users.${config.system.users.default.name} = {
      programs.kitty = {
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
        settings = with config.system; {
          enable_audio_bell = false;

          draw_minimal_borders = true;
          window_margin_width = 1;
          window_padding_width = 2;

          inactive_text_alpha = "1";

          tab_bar_style = "slant";
          tab_bar_align = "center";
          tab_bar_min_tabs = 1;
          #tab_activity_symbol = "!";

          enabled_layouts = "splits:split_axis=splits";

          allow_remote_control = lib.optionalString cfg.remoteControl "yes";

          # THEMING
          background = "#${colors.bg}";
          foreground = "#${colors.fg}";
          selection_background = "#${colors.magenta}";
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
