{ lib, pkgs, config, ... }:
let
  cfg = config.apps.eza;
in {
  options.apps.eza = {
    enable = lib.mkEnableOption "eza, the ls alternative";
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
    environment.systemPackages = with pkgs; [
      eza
    ];
    home-manager.users.${config.system.users.default.name}.programs.eza = {
      enableZshIntegration = cfg.overrides.zsh.enable;
      enableBashIntegration = cfg.overrides.bash.enable;
      enableFishIntegration = cfg.overrides.fish.enable;
      enableIonIntegration = cfg.overrides.ion.enable;
      enableNushellIntegration = cfg.overrides.nushell.enable;
    };
  };
}
