{ lib, config, pkgs, ... }: 
with lib;
let
  cfg = config.modules.system.shell.zsh;
in {
  options.shells.zsh = {
    enable = mkEnableOption "base zsh";
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {ll = "ls -la";};
      description = "aliases for the zsh shell";
    };
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
      history.ignoreSpace = true;
      historySubstringSearch = {
        enable = true;
	searchDownKey = "\\eOB";
	searchUpKey = "\\eOA";
      };
    };
  };
}
