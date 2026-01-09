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
        default = "./playlists";
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
    sops.secrets."service/navidrome/passwordEncryptionKey" = {
      owner = cfg.user;
      group = cfg.group;
    };
    sops.templates."navidrome.env".content = ''
      PasswordEncryptionKey=${config.sops.placeholder."service/navidrome/passwordEncryptionKey"}
    '';

    hosting.enabledServices = ["navidrome"];
    systemd.services.navidrome = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig.ProtectHome = lib.mkForce "read-only";
    };
    services.navidrome = {
      enable = true;
      group = cfg.group;
      user = cfg.user;
      openFirewall = cfg.openFirewall;

      environmentFile = config.sops.templates."navidrome.env".path;
      settings = {
        Address = cfg.ip;
        EnableInsightsCollector = false;
        Port = cfg.port;

        MusicFolder = cfg.directories.music;
        DataFolder = cfg.directories.data;
        #PlaylistsPath = cfg.directories.playlist;

        AutoImportPlaylists = true;

        CoverArtPriority = "embedded, cover.*, folder.*, front.*, external";

        DefaultShareExpiration = "24h";
        DefaultDownloadableShare = false;

        EnableDownloads = true;
      };
    };
  };
}
