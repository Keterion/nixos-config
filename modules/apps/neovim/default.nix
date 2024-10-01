{ lib, pkgs, config, ... }:
let
  cfg = config.modules.apps;
in
{
  options.modules.apps.neovim = {
    enable = lib.mkEnableOption "the neovim text editor";
  };

  config = lib.mkIf cfg.neovim.enable {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
	vimplugin-chadtree
	vimplugin-lualine.nvim
	nvim-colorizer-lua
	(nvim-treesitter.withPlugins (p: [
	  p.tree-sitter-nix
	  p.tree-sitter-bash
	  p.tree-sitter-
	])); #TODO

	aerial-nvim
	#outline-nvim

	#vimplugin-autoclose.nvim
	vim-closer
	
	nvim-lspconfig

	nvim-cmp
	cmp-nvim-lsp
	#cmp_luasnip
	#luasnip
	#friendly-snippets # might not work with luasnip out of the box

	#emmet-vim
	
	#conform-nvim
      ];
    };
  }
}
