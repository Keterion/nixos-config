{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.rust = {
    enable = lib.mkEnableOption "rust development";
  };
  config = lib.mkIf cfg.rust.enable {
    environment.systemPackages = lib.optionals (cfg.influences.packageInstall && cfg.influences.editor.lsp.enable) [
      pkgs.rust-analyzer# required for nix lsp to work
    ] ++ lib.optionals cfg.influences.packageInstall[
      pkgs.rustup
      pkgs.cargo
      pkgs.clippy
      pkgs.bacon
      pkgs.rustc
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
          lsp.servers.rust_analyzer = {
	    enable = cfg.influences.editor.lsp.enable;
	    installCargo = false;
	    installRustc = false;
	  };
	  lsp-format.enable = cfg.influences.editor.formatting.enable;
	  treesitter.grammarPackages = lib.optionals cfg.influences.editor.highlight.enable [
	    pkgs.vimPlugins.nvim-treesitter.builtGrammars.rust
	  ];
          cmp.settings.sources = lib.optionals cfg.influences.editor.autocomplete.enable [{name="rust_analyzer";}];
        };
      };
    };
  };
}
