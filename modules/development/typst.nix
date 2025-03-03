{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.typst = {
    enable = lib.mkEnableOption "rust development";
  };
  config = lib.mkIf cfg.typst.enable {
    environment.systemPackages = lib.optionals (cfg.influences.packageInstall && cfg.influences.editor.lsp.enable) [
      pkgs.typst-lsp # required for nix lsp to work
    ] ++ lib.optionals cfg.influences.packageInstall [
      pkgs.typst
    ];
    
    # packageInstall 
    # editor:
    # - lsp 
    # - highlight 
    # - formatting 
    # - autocomplete 
    home-manager.users.${config.vars.globals.defaultUser.name}.programs = {
      nixvim = lib.mkIf cfg.influences.editor.enable {
        plugins = {
          lsp.servers.tinymist.enable = cfg.influences.editor.lsp.enable;
	  lsp-format.enable = cfg.influences.editor.formatting.enable;
	  treesitter.grammarPackages = lib.optionals cfg.influences.editor.highlight.enable [
	    pkgs.vimPlugins.nvim-treesitter.builtGrammars.typst
	  ];
          #cmp.settings.sources = lib.optionals cfg.influences.editor.autocomplete.enable [{name="rust_analyzer";}];
        };
      };
    };
  };
}
