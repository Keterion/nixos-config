{ lib, pkgs, config, ... }:
let
  cfg = config.modules.apps.nixvim;
in {
  options.modules.apps.nixvim = {
    enable = lib.mkEnableOption "the nixvim editor";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nixd
    ];
    programs.nixvim = {
      enable = true;

      colorschemes.tokyonight.enable = true;

      opts = {
	number = true;
	relativenumber = false;
	shiftwidth = 2;

	cursorline = true;
      };

      keymaps = [
        {
	  action = ":CHADopen<CR>";
	  key = "<C-n>";
	  mode = "n";
	}
	
	{
	  action = "vim.lsp.buf.rename";
	  key = "<leader>rn";
	  mode = "n";
	}{
	  action = "vim.lsp.buf.code_action";
	  key = "<leader>ca";
	  mode = "n";
	}{
	  action = "vim.lsp.buf.definition";
	  key = "gd";
	  mode = "n";
	}{
	  action = "vim.lsp.buf.implementation";
	  key = "gi";
	  mode = "n";
	}{
	  action = "require('telescope.builtin').lsp_references";
	  key = "gr";
	  mode = "n";
	}{
	  action = "vim.lsp.buf.hover";
	  key = "K";
	  mode = "n";
	}

	{
	  action = ":AerialToggle<CR>";
	  key = "<c-o>";
	  mode = "n";
	}
	
	{
	  action = "telescope.builtin.find_files";
	  key = "<c-p>";
	  mode = "n";
	}{
	  action = "telescope.builtin.oldfiles";
	  key = "<Space><Space>";
	  mode = "n";
	}{
	  action = "telescope.builtin.live_grep";
	  key = "<Space>fg";
	  mode = "n";
	}{
	  action = "telescope.builtin.help_tags";
	  key = "<Space>fh";
	  mode = "n";
	}
      ];

      plugins = {
	lsp = {
	  enable = true;
	};


        web-devicons.enable = true;
	chadtree = {
	  enable = true;
	  options.showHidden = true;
	};
	lualine = {
	  enable = true;
	  settings = {
	    options = {
	      icons_enabled = true;
	    };
	    sections = {
	      lualine_a = [
	        "filename"
		{ path = 1; }
	      ];
	    };
	  };
	};
	nvim-colorizer = {
	  enable = true;
	};
	treesitter = {
	  enable = true;

	  grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
	    bash
	    markdown
	  ];
	  folding = false;

	  settings = {
	    highlight.enable = true;
	  };
	};
	nvim-autopairs = {
	  settings = {
	    map_cr = true;
	  };
	};
	#autoclose = {
	#  enable = false;
	#  options = {
	#    disabledFiletypes = [
	#      "text"
	#      "markdown"
	#      "typst"
	#    ];
	#  };
	#};

	luasnip = {
	  enable = true;
	};

	cmp = {
	  enable = true;
	  autoEnableSources = true;
	  settings = {
	    mapping = {
	      "<C-j>" = "cmp.mapping.select_next_item()";
	      "<C-k>" = "cmp.mapping.select_prev_item()";
	      "<C-e>" = "cmp.mapping.abort()";
	      "<C-b>" = "cmp.mapping.scroll_docs(-4)";
	      "<C-f>" = "cmp.mapping.scroll_docs(4)";
	      "<C-Space>" = "cmp.mapping.complete()";
	      "<C-CR>" = "cmp.mapping.confirm({ select = true })";
	    };
	    sources = [
	      { name = "luasnip"; }
	      { name = "nvim_lsp"; }
	      { name = "path"; }
	      { name = "buffer"; }
	    ];
	    snippet.expand = ''
	      function(args)
	        require('luasnip').lsp_expand(args.body)
	      end
	    '';
	  };
	};
	telescope = {
	  enable = true;
	};
      };
      extraPlugins = with pkgs.vimPlugins; [
	aerial-nvim
      ];
      extraConfigLua = ''require('aerial').setup({
	backends = { "treesitter", "lsp" }
      })'';
    };
  };
}
