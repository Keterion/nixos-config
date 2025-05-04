{
  lib,
  config,
  ...
}: let
  cfg = config.system.shell.prompt.starship;
in {
  options.system.shell.prompt.starship = {
    enable = lib.mkEnableOption "the starship prompt";
  };
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        palettes.custom = with config.system; {
          fg = "#${colors.fg}";
          fg_dark = "#${colors.fg_dark}";
          bg = "#${colors.bg}";
          bg_dark = "#${colors.bg_dark}";
          # colors
          blue1 = "#${colors.blue1}";
          blue2 = "#${colors.blue2}";
          blue3 = "#${colors.blue3}";
          cyan = "#${colors.cyan}";
          green = "#${colors.green}";
          magenta = "#${colors.magenta}";
          orange = "#${colors.orange}";
          purple = "#${colors.purple}";
          red1 = "#${colors.red1}";
          red2 = "#${colors.red2}";
          teal = "#${colors.teal}";
          yellow = "#${colors.yellow}";
        };
        palette = "custom";

        username = {
          style_user = "blue1 bold";
          style_root = "red1 bold";
          format = "[$user]($style)";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "[$hostname](bold red1) ";
          trim_at = ".local";
          disabled = false;
        };
        directory = {
          disabled = false;
          fish_style_pwd_dir_length = 3;
          read_only_style = "red2";
          read_only = " !";
          style = "cyan";
          format = "[$path]($style)[$read_only]($read_only_style)";
        };
        character = {
          format = "$symbol > ";
          disabled = false;
          success_symbol = "[0](bold green)";
          error_symbol = "[1](bold red2)";
        };
        format = "$username@$hostname\n$directory $character";
      };
    };
  };
}
