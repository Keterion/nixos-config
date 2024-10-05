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
      plugins.lualine.enable = true;
    };
  };
}
