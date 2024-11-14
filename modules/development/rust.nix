{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.nix = {
    enable = lib.mkEnableOption "rust development";
  };
  config = lib.mkIf cfg.nix.enable {
    environment.systemPackages =  with pkgs; b.optionals cfg.influences.systemPackages.enable [
      cargo
      rustup
    ];

    home-manager.users.${config.vars.globals.defaultUser.name}.home.programs.nixvim = lib.mkIf config.modules.apps.nixvim.enable {
      plugins = {
        lsp.servers.rust_analyzer.enable = true;
	treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.rust];
	cmp.settings.sources = [{name="rust_analyzer";}];
      };
    };
  };
}
