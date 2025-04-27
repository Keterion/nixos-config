{ lib, pkgs, config, ... }:
let
  cfg = config.apps.keepassxc;
in {
  options.apps.keepassxc.enable = lib.mkEnableOption "keepassxc for keepass databases";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
