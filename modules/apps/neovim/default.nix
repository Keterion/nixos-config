{ lib, pkgs, config, ... }:
let
  cfg = config.modules.apps;
in
{
  options.modules.apps.neovim = {
    enable = lib.mkEnableOption "the neovim text editor";
  };

  config = lib.mkIf cfg.neovim.enable {
    programs.neovim = 
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
	{
	  plugin = chadtree;
	  config = toLua ''
	    vim.g.loaded_netrw = 1
	    vim.g.loaded_netrwPlugin = 1
	    vim.keymap.set('n', '<c-n>', ':CHADopen<CR>')
	  '';
	}
	{
	  plugin = lualine-nvim;
	  config = toLua ''
	    require('lualine').setup {
	      options = {
	        icons_enabled = true,
	      },
	      sections = {
	        lualine_a = {{
	          'filename',
	          path = 1,
	        }}
	      }
	    }
	  '';
	}
	nvim-colorizer-lua
	(nvim-treesitter.withPlugins (p: [
	  p.tree-sitter-nix
	  p.tree-sitter-bash
	])) #TODO

	#aerial-nvim # TODO
	{
	  plugin = outline-nvim;
	  config = toLua ''
	    require("outline").setup({
	      outline_window = {
	       position = 'right',
	       width = 15,
	       relative_width = true,
	       auto_close = true,
	      },
	      outline_items = { show_symbol_lineno = false, },
	      guides = { enabled = true, },
	      symbol_folding = { autofold_depth = 2, },
	    })
	    vim.keymap.set('n', '<c-o>', ':Outline<CR>')
	  '';
	}

	#autoclose.nvim
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

      extraLuaConfig = ''
      '';
    };
  };
}
