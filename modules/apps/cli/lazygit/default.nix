{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.lazygit;
  settingsFormat = pkgs.formats.yaml {};
  settings = {
    gui.nerdFontsVersion = "3";
    gui.theme = with config.system; {
      lightTheme = false;
      activeBorderColor = [
        "#${colors.purple}"
        "bold"
      ];
      inactiveBorderColor = [
        "#${colors.blue1}"
        "bold"
      ];
      optionsTextColor = ["#${colors.blue1}"];
      selectedLineBgColor = ["#${colors.blue1}"];
      cherryPickedCommitBgColor = ["#${colors.cyan}"];
      cherryPickedCommitFgColor = ["#${colors.blue1}"];
      unstagedChangesColor = ["#${colors.red1}"];
      defaultFgColor = ["#${colors.fg}"];
      searchingActiveBorderColor = ["#${colors.cyan}"];
    };
  };
in {
  options.apps.lazygit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.apps.modules.cli.utils.enable;
    };
    settings = lib.mkOption {
      type = settingsFormat;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = settings;
    };
    home-manager.users.${config.system.users.default.name}.programs.lazygit = {
      enable = true;
      settings = settings;
    };
  };
}
