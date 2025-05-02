{ lib, pkgs, config, ... }:
let
  cfg = config.apps.spotdl;
in {
  options.apps.spotdl.enable = lib.mkOption {
    default = config.apps.modules.cli.dl.enable;
    type = lib.types.bool;
    description = "Whether to enable spotdl.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotdl
    ];
  };
}
