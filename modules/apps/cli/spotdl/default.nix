{ lib, pkgs, config, ... }:
let
  cfg = config.apps.spotdl;
in {
  options.apps.spotdl.enable = lib.mkEnableOption "spotdl";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotdl
    ];
  };
}
