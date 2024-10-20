{ lib, pkgs, config, ... }:
let
  cfg = config.modules.apps.nixvim;
in {
  options.modules.apps.nixvim = {
    enable = lib.mkEnableOption "the nixvim editor";
  };
  config = lib.mkIf cfg.enable {
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
	  key = "<c-n>";
	  mode = "n";
	}
	{
	  key = "<C-j>";
	  action = "cmp.mapping.select_next_item()";
	}
        {
	  key = "<C-k>";
	  action = "cmp.mapping.select_prev_item()";
	}
        {
	  key = "<C-e>";
	  action = "cmp.mapping.abort()";
	}
        {
	  key = "<C-b>";
	  action = "cmp.mapping.scroll_docs(-4)";
	}
        {
	  key = "<C-f>";
	  action = "cmp.mapping.scroll_docs(4)";
	}
        {
	  key = "<C-Space>";
	  action = "cmp.mapping.complete()";
	}
        {
	  key = "<CR>";
	  action = "cmp.mapping.confirm({ select = true })";
	}
	{
	  action = "vim.lsp.buf.rename";
	  key = "<leader>rn";
	}{
	  action = "vim.lsp.buf.code_action";
	  key = "<leader>ca";
	}{
	  action = "vim.lsp.buf.definition";
	  key = "gd";
	}{
	  action = "vim.lsp.buf.implementation";
	  key = "gi";
	}{
	  action = "require('telescope.builtin').lsp_references";
	  key = "gr";
	}{
	  action = "vim.lsp.buf.hover";
	  key = "K";
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
	  servers = {
	    typst-lsp.enable = true;
	    rust-analyzer.enable = true;
	  };
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
	    nix
	    rust
	  ];
	  folding = false;

	  settings = {
	    highlight.enable = true;
	  };
	};
	autoclose = {
	  enable = true;
	  options = {
	    disabledFiletypes = [
	      "text"
	      "markdown"
	      "typst"
	    ];
	  };
	};

	luasnip = {
	  enable = true;
	};

	cmp = {
	  enable = true;
	  autoEnableSources = true;
	  settings.sources = [
	    { name = "nvim_lsp"; }
	    { name = "path"; }
	    { name = "buffer"; }
	    { name = "luasnip"; }
	  ];
	  settings.snippet.expand = ''
	    function(args)
	      require('luasnip').lsp_expand(args.body)
	    end
	  '';
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
