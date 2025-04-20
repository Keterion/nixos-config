{ config, lib, myUtils, ... }:
let
  cfg = config.system.shell.zsh;
in {
  options.system.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
    global = {
      autosuggestions.enable = lib.mkEnableOption "autosuggestions";
      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        example = {ll = "ls -la";};
        description = "Aliases for zsh, overwrites the aliases used for all shells";
      };
    };
    user = {
      autocd = lib.mkEnableOption "automatically entering typed directories without cd";
      autosuggestion = {
	enable = lib.mkEnableOption "autosuggestions";
	highlight = lib.mkOption {
	  type = lib.types.str;
	  default = "underline";
	  description = "Highlighting style to use, {manpage} zshzle(1) for syntax";
	};
      };
      enableCompletion = lib.mkEnableOption "zsh completion";
      aliases = lib.mkOption {
	type = lib.types.attrsOf lib.types.str;
	default = {};
	description = "Aliases available at user level";
      };
      history = {
	ignoreDups = myUtils.mkEnabledOption "not saving repetitions of the same command to history.";
	ignoreSpace = lib.mkEnableOption "not saving commands with a Space character prepended";
	substringSearch = {
	  enable = lib.mkEnableOption "history substring search";
	  searchDownKey = lib.mkOption {
	    default = "\\eOB"; # arrow down
	    type = lib.types.str;
	    description = "Key to use to cycle downwards";
	  };
	  searchUpKey = lib.mkOption {
	    default = "\\eOA";
	    type = lib.types.str;
	    description = "Key to use to cycle upwards";
	  };
	};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestions = {
	enable = cfg.global.autosuggestions.enable;
	highlightStyle = "underline";
      };
      enableCompletion = true;
      shellAliases = cfg.global.aliases;
    };
    home-manager.users.${config.system.users.default.name}.programs.zsh = {
      enable = cfg.enable;
      autocd = cfg.user.autocd;
      autosuggestion = {
	enable = cfg.user.autosuggestion.enable;
	highlight = cfg.user.autosuggestion.highlight;
      };
      enableCompletion = cfg.user.enableCompletion;
      shellAliases = cfg.user.aliases;
      history = {
	ignoreDups = cfg.user.history.ignoreDups;
	ignoreSpace = cfg.user.history.ignoreSpace;
      };
      historySubstringSearch = {
	enable = cfg.user.history.substringSearch.enable;
	searchDownKey = cfg.user.history.substringSearch.searchDownKey;
	searchUpKey = cfg.user.history.substringSearch.searchUpKey;
      };
    };
  };
}
