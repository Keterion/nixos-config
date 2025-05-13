{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.monit;
  storeRegex = "\/nix\/store\/.{32,}";
  fsType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Unique name for the filesystem displayed in monit";
        example = "root";
      };
      path = lib.mkOption {
        type = lib.types.path;
        description = "Path for the filesystem";
        example = "/";
      };
    };
  };
in {
  options.hosting.monit = {
    enable = lib.mkEnableOption "monit, the monitor for pretty much everything";
    port = lib.mkOption {
      type = lib.types.port;
      default = 2812;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    fileSystems = lib.mkOption {
      type = lib.types.listOf fsType;
      default = [];
      description = "File systems to be monitored";
      example = [
        {
          name = "root";
          path = "/";
        }
        {
          name = "foo";
          path = "/mnt/foo";
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."monit/user".source = ./htpasswd;

    services.monit = {
      enable = true;
      config = with config.hosting;
        ''
          SET DAEMON 5
          SET HTTPD PORT ${toString cfg.port}
              ALLOW md5 /etc/monit/user
        ''
        + lib.concatMapStringsSep "\n" (x: x) (map (fs: "CHECK FILESYSTEM ${fs.name} PATH ${fs.path}") cfg.fileSystems)
        + lib.optionalString (bazarr.monitor.enable && bazarr.enable) "\nCHECK PROCESS bazarr MATCHING '${storeRegex}.*bazarr'"
        + lib.optionalString (calibre.server.monitor.enable && calibre.server.enable) "\nCHECK PROCESS calibre-server MATCHING '${storeRegex}.*calibre-server'"
        + lib.optionalString (calibre.web.monitor.enable && calibre.web.enable) "\nCHECK PROCESS calibre-web MATCHING '${storeRegex}.*calibre-web'"
        + lib.optionalString (grocy.monitor.enable && grocy.enable) "\nCHECK PROCESS grocy MATCHING '${storeRegex}.*grocy'"
        + lib.optionalString (jellyfin.monitor.enable && jellyfin.enable) "\nCHECK PROCESS jellyfin MATCHING '${storeRegex}.*jellyfin'"
        + lib.optionalString (jellyseerr.monitor.enable && jellyseerr.enable) "\nCHECK PROCESS jellyseerr MATCHING '${storeRegex}.*jellyseerr'"
        + lib.optionalString (prowlarr.monitor.enable && prowlarr.enable) "\nCHECK PROCESS prowlarr MATCHING '${storeRegex}.*prowlarr'"
        + lib.optionalString (qbittorrent.monitor.enable && qbittorrent.enable) "\nCHECK PROCESS qbittorrent MATCHING '${storeRegex}.*qbittorrent'"
        + lib.optionalString (radarr.monitor.enable && radarr.enable) "\nCHECK PROCESS radarr MATCHING '${storeRegex}.*radarr'"
        + lib.optionalString (radicale.monitor.enable && radicale.enable) "\nCHECK PROCESS radicale MATCHING '${storeRegex}.*radicale'"
        + lib.optionalString (rustypaste.monitor.enable && rustypaste.enable) "\nCHECK PROCESS rustypaste MATCHING '${storeRegex}.*rustypaste'"
        + lib.optionalString (sonarr.monitor.enable && sonarr.enable) "\nCHECK PROCESS sonarr MATCHING '${storeRegex}.*sonarr'"
        + lib.optionalString (syncthing.monitor.enable && syncthing.enable) "\nCHECK PROCESS syncthing MATCHING '${storeRegex}.*syncthing'"
        + lib.optionalString (tandoor.monitor.enable && tandoor.enable) "\nCHECK PROCESS tandoor MATCHING '${storeRegex}.*gunicorn'";
    };
  };
}
