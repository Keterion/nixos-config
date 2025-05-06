{ lib, pkgs, config, ... }:
let
  cfg = config.apps.tdf;
in {
  options.apps.tdf.enable = lib.mkOption {
    default = config.apps.modules.cli.media.enable;
    type = lib.types.bool;
    description = "Whether to enable tdf for viewing pdfs in supported terminals.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tdf
    ];
  };
}
