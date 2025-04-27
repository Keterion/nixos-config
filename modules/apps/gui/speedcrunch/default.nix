{ lib, pkgs, config, ... }:
let
  cfg = config.apps.speedcrunch;
in {
  options.apps.speedcrunch.enable = lib.mkEnableOption "speedcrunch";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      speedcrunch
    ];
  };
}
