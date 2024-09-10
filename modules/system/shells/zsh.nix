{ lib, config, pkgs, ... }: 
with lib;
let
  cfg = config.shells.zsh;
in {
  options.shells.zsh = {
    enable = mkEnableOption "base zsh";
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {ll = "ls -la";};
      description = "aliases for the zsh shell";
    };
    eza.enable = mkEnableOption "eza";
    fzf.enable = mkEnableOption "fzf";
    zoxide.enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
	highlight = "underline";
      };
      enableCompletion = true;
      shellAliases = cfg.aliases;
      history.ignoreDups = true;
      historySubstringSearch = {
        enable = true;
	searchDownKey = "\\eOB";
	searchUpKey = "\\eOA";
      };
    };

    programs.eza = mkIf cfg.eza.enable {
      enable = true;
      enableZshIntegration = true;
    };
    programs.fzf = mkIf cfg.fzf.enable {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zoxide = mkIf cfg.zoxide.enable {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
