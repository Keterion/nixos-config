{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.fzf;
in {
  options.apps.fzf = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
    };
    shellIntegration = lib.mkEnableOption "shell integration";
    overrides.shellIntegration = {
      zsh.enable = lib.mkOption {
        default = cfg.shellIntegration;
        type = lib.types.bool;
      };
      bash.enable = lib.mkOption {
        default = cfg.shellIntegration;
        type = lib.types.bool;
      };
      fish.enable = lib.mkOption {
        default = cfg.shellIntegration;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.fzf = {
      enable = true;
      enableZshIntegration = cfg.overrides.shellIntegration.zsh.enable;
      enableBashIntegration = cfg.overrides.shellIntegration.bash.enable;
      enableFishIntegration = cfg.overrides.shellIntegration.fish.enable;
    };
  };
}
