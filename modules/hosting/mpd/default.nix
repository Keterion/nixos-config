{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.mpd;
in {
  options.hosting.mpd = {
    enable = lib.mkEnableOption "MPD, the music player daemon";
    directories = {
      music = lib.mkOption {
        type = lib.types.str;
        default = "${config.services.mpd.dataDir}/music";
      };
      playlist = lib.mkOption {
        type = lib.types.str;
        default = "${config.services.mpd.dataDir}/playlists";
      };
    };
    startWhenNeeded = lib.mkEnableOption "a socket service to start mpd only on-demand";
    user = lib.mkOption {
      type = lib.types.str;
      default = config.services.mpd.user;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = config.services.mpd.network.port;
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      playlistDirectory = cfg.directories.playlist;
      musicDirectory = cfg.directories.music;
      user = cfg.user;
      network.listenAddress = cfg.ip;
      network.port = cfg.port;
    };
  };
}
