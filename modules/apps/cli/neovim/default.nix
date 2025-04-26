{ lib, pkgs, config, ... }: 
let
  cfg = config.apps.neovim;
in {
  options.apps.neovim = {
    enable = lib.mkEnableOption "neovim configured via nvf";
    aliases.enable = lib.mkEnableOption "aliases for vi";
    default = lib.mkEnableOption "neovim as the default text editor";
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
	viAlias = cfg.aliases.enable;
      	vimAlias = cfg.aliases.enable;
      	
      	filetree.neo-tree = {
      	  enable = true;
      	};

      	defaultEditor = true;

      	statusline.lualine.enable = true;
      	autocomplete.nvim-cmp.enable = true;

      	languages = {
      	  enableLSP = true;

      	  rust = {
      	    enable = true;
      	    format.enable = true;
      	    lsp = {
      	      enable = true;
      	    };
      	    treesitter.enable = true;
      	  };
      	  nix = {
      	    enable = true;
      	    format.enable = true;
      	    lsp.enable = true;
      	    treesitter.enable = true;
      	  };
      	  python = {
      	    enable = true;
      	    format.enable = true;
      	    lsp.enable = true;
      	    treesitter.enable = true;
      	  };
      	  typst = {
      	    enable = true;
      	    format.enable = true;
      	    lsp.enable = true;
      	    treesitter.enable = true;
      	  };
      	};
      	extraPlugins = {
      	  aerial = {
      	    package = pkgs.vimPlugins.aerial-nvim;
      	    setup = "require('aerial').setup {}";
      	  };
      	};
      };
    };
  };
}
