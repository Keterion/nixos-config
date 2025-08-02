{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hosting.navidrome;
in {
  options.hosting.navidrome = {
    enable = lib.mkEnableOption "navidrome";

    directories = {
      data = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/navidrome";
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

    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "navidrome";
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
      default = 4533;
    };
    monitor.enable = lib.mkEnableOption "monitoring of the navidrome service, disabled except if explicitly enabled";
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["navidrome"];
    systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce "read-only";
    services.navidrome = {
      enable = true;
      group = cfg.group;
      user = cfg.user;
      openFirewall = cfg.openFirewall;

      settings = {
        Address = cfg.ip;
        EnableInsightsCollector = false;
        Port = cfg.port;

        MusicFolder = cfg.directories.music;
        DataFolder = cfg.directories.data;
        PlaylistsPath = cfg.directories.playlist;

        CoverArtPriority = "embedded, cover.*, folder.*, front.*, external";

        DefaultShareExpiration = "24h";
        DefaultDownloadableShare = false;

        EnableDownloads = true;
      };
    };
  };
}
