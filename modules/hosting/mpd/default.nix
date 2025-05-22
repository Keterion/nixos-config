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
      data = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/mpd";
      };
      music = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.directories.data}/music";
      };
      playlist = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.directories.data}/playlists";
      };
    };
    startWhenNeeded = lib.mkEnableOption "a socket service to start mpd only on-demand";
    user = lib.mkOption {
      type = lib.types.str;
      default = "mpd";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 6600;
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      playlistDirectory = cfg.directories.playlist;
      musicDirectory = cfg.directories.music;
      user = cfg.user;
      group = cfg.group;
      network.listenAddress = cfg.ip;
      network.port = cfg.port;
      startWhenNeeded = cfg.startWhenNeeded;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Default"
        }
      '';
    };

    systemd.services.mpd.environment.XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${cfg.user}.uid}";
  };
}
