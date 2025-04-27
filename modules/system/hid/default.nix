{ lib, pkgs, config, ... }:
let
  cfg = config.system.hid;
in {
  options.system.hid = {
    gamepad = {
      dualsense.enable = lib.mkEnableOption "PlayStation Dualsense Controller support";
    };
  };

  config = {
    environment.systemPackages = with pkgs; lib.optionals cfg.gamepad.dualsense.enable [
      dualsensectl
    ];
  };
}
