{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.python = {
    enable = lib.mkEnableOption "python development";
  };
  config = lib.mkIf cfg.rust.enable {
    environment.systemPackages = lib.optionals (cfg.influences.packageInstall && cfg.influences.editor.lsp.enable) [
    ] ++ lib.optionals cfg.influences.packageInstall[
      pkgs.python
      pkgs.black
    ];
    
    # packageInstall x
    # editor:
    # - lsp x
    # - highlight x
    # - formatting 
    # - autocomplete x
    home-manager.users.${config.vars.globals.defaultUser.name}.programs = {
      nixvim = lib.mkIf cfg.influences.editor.enable {
        plugins = {
          lsp.servers.pyright = {
	    enable = cfg.influences.editor.lsp.enable;
	  };
	  lsp-format.enable = cfg.influences.editor.formatting.enable;
	  treesitter.grammarPackages = lib.optionals cfg.influences.editor.highlight.enable [
	    pkgs.vimPlugins.nvim-treesitter.builtGrammars.python
	  ];
          #cmp.settings.sources = lib.optionals cfg.influences.editor.autocomplete.enable [{name="";}];
        };
      };
    };
  };
}
