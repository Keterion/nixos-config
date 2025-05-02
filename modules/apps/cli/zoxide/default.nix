{ lib, pkgs, config, ... }:
let
  cfg = config.apps.zoxide;
in {
  options.apps.zoxide = {
    enable = lib.mkEnableOption "zoxide, the cd alternative";
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
    environment.systemPackages = with pkgs; [
      zoxide
    ];
    home-manager.users.${config.system.users.default.name}.programs.zoxide = {
      enableZshIntegration = cfg.overrides.zsh.enable;
      enableBashIntegration = cfg.overrides.bash.enable;
      enableFishIntegration = cfg.overrides.fish.enable;
      enableNushellIntegration = cfg.overrides.nushell.enable;
    };

    system.shell.zsh.global.aliases = lib.mkIf config.system.shell.zsh.enable { "cd" = "z"; };
  };
}
