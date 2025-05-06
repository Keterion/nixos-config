{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.eza;
in {
  options.apps.eza = {
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
      nushell.enable = lib.mkOption {
        default = cfg.shellIntegration;
        type = lib.types.bool;
      };
      ion.enable = lib.mkOption {
        default = cfg.shellIntegration;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.eza = {
      enable = true;
      enableZshIntegration = cfg.overrides.shellIntegration.zsh.enable;
      enableBashIntegration = cfg.overrides.shellIntegration.bash.enable;
      enableFishIntegration = cfg.overrides.shellIntegration.fish.enable;
      enableIonIntegration = cfg.overrides.shellIntegration.ion.enable;
      enableNushellIntegration = cfg.overrides.shellIntegration.nushell.enable;
    };
  };
}
