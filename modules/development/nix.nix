{ lib, pkgs, config, ...}:
let
  cfg = config.modules.development;
in {
  options.modules.development.nix = {
    enable = lib.mkEnableOption "nix development";
  };
  config = lib.mkIf cfg.nix.enable {
    environment.systemPackages = lib.optionals cfg.influences.systemPackages.enable [
      pkgs.nixd
    ];

    home-manager.users.${config.vars.globals.defaultUser.name}.home.programs.nixvim = lib.mkIf config.modules.apps.nixvim.enable {
      plugins = {
        lsp.servers.nixd.enable = true;
	treesitter.grammarPackages = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.bash];
	cmp.settings.sources = [{name="nixd";}];
      };
    };
  };
}
