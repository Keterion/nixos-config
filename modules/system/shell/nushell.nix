{ lib, pkgs, config, ...}:
let
  cfg = config.modules.system.shell.nu;
in {
  options.modules.system.shell.nu = {
    enable = lib.mkEnableOption "the nu shell";
    eza.enable = lib.mkEnableOption "eza";
    fzf.enable = lib.mkEnableOption "fzf";
    zoxide.enable = lib.mkEnableOption "zoxide";
  };
  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
    };
  };
}
