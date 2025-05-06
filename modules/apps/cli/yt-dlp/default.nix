 { lib, pkgs, config, ... }:
let
  cfg = config.apps.yt-dlp;
in {
  options.apps.yt-dlp.enable = lib.mkOption {
    default = config.apps.modules.cli.dl.enable;
    type = lib.types.bool;
    description = "Whether to enable yt-dlp to download video streams.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yt-dlp
    ];
  };
}
