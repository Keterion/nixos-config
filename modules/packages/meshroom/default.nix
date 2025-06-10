{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.meshroom;
in {
  options.programs.meshroom.enable = lib.mkEnableOption "Meshroom v2023.3.0";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        meshroom = pkgs.callPackage ./meshroom.nix {};
      })
    ];
  };
}
