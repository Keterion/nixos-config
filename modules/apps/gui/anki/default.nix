{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.anki;
in {
  options.apps.anki.enable = lib.mkEnableOption "anki";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      anki
    ];
  };
}
