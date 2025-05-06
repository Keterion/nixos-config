 { lib, pkgs, config, ... }:
let
  cfg = config.apps.exiftool;
in {
  options.apps.exiftool.enable = lib.mkOption {
    default = config.apps.modules.cli.media.enable;
    type = lib.types.bool;
    description = "Whether to enable exiftool for reading and editing exif metadata.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      exiftool
    ];
  };
}
