{ lib, pkgs, config, ... }:
let
  cfg = config.system.bluetooth;
in {
  options.system.bluetooth.enable = lib.mkEnableOption "bluetooth support";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
