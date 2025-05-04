{ lib, pkgs, config, ... }:
let
  cfg = config.system.hid;
in {
  options.system.hid = {
    gamepad = {
      dualsense.enable = lib.mkEnableOption "PlayStation Dualsense Controller support";
    };
    tablet = {
      enable = lib.mkEnableOption "tablet support via opentabletdriver";
    };
  };

  config = {
    environment.systemPackages = with pkgs; lib.optionals cfg.gamepad.dualsense.enable [
      dualsensectl
    ];
    hardware.opentabletdriver = {
      enable = cfg.tablet.enable;
      daemon.enable = cfg.tablet.enable;
    };
  };
}
