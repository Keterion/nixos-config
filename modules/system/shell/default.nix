{ lib, config, ...}:
let
  cfg = config.system.shell;
in {
  imports = [
    ./zsh.nix
    ./nushell.nix
    ./prompt
  ];
  options.system.shell = {
    eza.enable = lib.mkEnableOption "eza integration for enabled shells";
    fzf.enable = lib.mkEnableOption "fzf integration for enabled shells";
    zoxide.enable = lib.mkEnableOption "zoxide integration for enabled shells";
  };
  config = {
    programs.fzf = lib.mkIf cfg.fzf.enable {
      enable = true;
      enableZshIntegration = cfg.zsh.enable;
    };
    programs.eza = lib.mkIf cfg.eza.enable {
      enable = true;
      enableZshIntegration = cfg.zsh.enable;
      #enableNushellIntegration = cfg.nushell.enable;
    };
    programs.zoxide = lib.mkIf cfg.zoxide.enable {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = cfg.nushell.enable;
    }; 
    programs.zsh.shellAliases = lib.attrsets.optionalAttrs cfg.zoxide.enable { "cd" = "z"; };

    programs.nushell.shellAliases = {}
      // lib.attrsets.optionalAttrs cfg.fzf.enable {}
      // lib.attrsets.optionalAttrs cfg.eza.enable {}
      // lib.attrsets.optionalAttrs cfg.zoxide.enable { "cd" = "z"; };
    #// lib.attrsets.optionalAttrs config.modules.system.shell.zoxide.enable { "cd" = "z"; }
  };
}
