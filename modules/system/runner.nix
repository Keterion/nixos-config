{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.system.runner;
in {
  imports = [
    ./runners/tofi_settings.nix
  ];
  options.system.runner = {
    tofi = {
      enable = mkEnableOption "tofi";
    };
  };
  config = {
    programs.tofi = mkIf cfg.tofi.enable {
      enable = true;
    };
  };
}
