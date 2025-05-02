 { lib, pkgs, config, ... }:
let
  cfg = config.apps.mediainfo;
in {
  options.apps.mediainfo.enable = lib.mkOption {
    default = config.apps.modules.cli.media.enable;
    type = lib.types.bool;
    description = "Whether to enable mediainfo.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mediainfo
    ];
  };
}
