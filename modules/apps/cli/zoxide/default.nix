{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.zoxide;
in {
  options.apps.zoxide = {
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
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = cfg.overrides.shellIntegration.bash.enable;
      enableFishIntegration = cfg.overrides.shellIntegration.fish.enable;
      enableNushellIntegration = cfg.overrides.shellIntegration.nushell.enable;
    };

    system.shell.zsh.user.aliases = lib.mkIf config.system.shell.zsh.enable {"cd" = "z";};
  };
}
