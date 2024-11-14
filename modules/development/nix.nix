{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.nix = {
    enable = lib.mkEnableOption "nix development";
  };
  config = lib.mkIf cfg.nix.enable {
    environment.systemPackages = lib.optionals (cfg.influences.installPackages.enable && cfg.influences.editor.lsp.enable) [
      pkgs.nixd # required for nix lsp to work
    ];
    
    # installPackages x
    # editor:
    # - lsp x
    # - highlight x
    # - formatting 
    # - autocomplete x
    home-manager.users.${config.vars.globals.defaultUser.name}.home.programs = {
      nixvim = lib.mkIf cfg.influences.editor.enable {
        plugins = {
          lsp.servers.nixd.enable = cfg.influences.editor.lsp.enable;
	  lsp-format.enable = cfg.influences.editor.formatting.enable;
          treesitter.grammarPackages = lib.optionals cfg.influences.editor.highlight.enable [
	    pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix
	  ];
          cmp.settings.sources = lib.optionals cfg.influences.editor.autocomplete.enable [{name="nixd";}];
        };
      };
    };
  };
}
