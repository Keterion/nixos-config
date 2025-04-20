{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.apps.neovim;
in {
  imports = [
    inputs.nvf.nixosModules.default
  ];
  options.apps.neovim = {
    enable = lib.mkEnableOption "the neovim text editor, configured via nvf";
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settigs = {
	vim.viAlias = true;
	vim.vimAlias = true;
	vim.lsp = {
	  enable = true;
	};
      };
    };
  };
}
