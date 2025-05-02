{ lib, pkgs, config, ... }:
let
  cfg = config.apps.fzf;
in {
  options.apps.fzf = {
    enable = lib.mkEnableOption "fzf, the cd alternative";
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
    environment.systemPackages = with pkgs; [
      fzf
    ];
    home-manager.users.${config.system.users.default.name}.programs.fzf = {
      enableZshIntegration = cfg.overrides.zsh.enable;
      enableBashIntegration = cfg.overrides.bash.enable;
      enableFishIntegration = cfg.overrides.fish.enable;
    };
  };
}
