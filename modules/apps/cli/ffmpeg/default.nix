 { lib, pkgs, config, ... }:
let
  cfg = config.apps.ffmpeg;
in {
  options.apps.ffmpeg.enable = lib.mkOption {
    default = config.apps.modules.cli.media.enable;
    type = lib.types.bool;
    description = "Whether to enable ffmpeg.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg
    ];
  };
}
