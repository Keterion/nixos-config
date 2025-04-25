{ lib, pkgs, config, ... }: 
let
  cfg = config.apps.neovim;
in {
  options.apps.neovim = {
    enable = lib.mkEnableOption "neovim configured via nvf";
    aliases.enable = lib.mkEnableOption "aliases for vi";
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      vim.viAlias = cfg.aliases.enable;
      vim.vimAlias = cfg.aliases.enable;
      
      vim.filetree.neo-tree = {
	enable = true;

      };

      vim.languages = {
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
      vim.extraPlugins = {
	aerial = {
	  package = pkgs.vimPlugins.aerial-nvim;
	  setup = "require('aerial').setup {}";
	};
      };

    };
  };
}
