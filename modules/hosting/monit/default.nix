{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.monit;
  storeRegex = "\/nix\/store\/.{32,}";
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
          CHECK FILESYSTEM root PATH "/"
        ''
        + lib.optionalString (bazarr.monitor.enable && bazarr.enable) ''CHECK PROCESS bazarr MATCHING "${storeRegex}.*bazarr"''
        + lib.optionalString (calibre.server.monitor.enable && calibre.server.enable) ''CHECK PROCESS calibre-server MATCHING "${storeRegex}.*calibre-server"''
        + lib.optionalString (calibre.web.monitor.enable && calibre.web.enable) ''CHECK PROCESS calibre-web MATCHING "${storeRegex}.*calibre-web"''
        + lib.optionalString (grocy.monitor.enable && grocy.enable) ''CHECK PROCESS grocy MATCHING "${storeRegex}.*grocy"''
        + lib.optionalString (jellyfin.monitor.enable && jellyfin.enable) ''CHECK PROCESS jellyfin MATCHING "${storeRegex}.*jellyfin"''
        + lib.optionalString (jellyseerr.monitor.enable && jellyseerr.enable) ''CHECK PROCESS jellyseerr MATCHING "${storeRegex}.*jellyseerr"''
        + lib.optionalString (prowlarr.monitor.enable && prowlarr.enable) ''CHECK PROCESS prowlarr MATCHING "${storeRegex}.*prowlarr"''
        + lib.optionalString (qbittorrent.monitor.enable && qbittorrent.enable) ''CHECK PROCESS qbittorrent MATCHING "${storeRegex}.*qbittorrent"''
        + lib.optionalString (radarr.monitor.enable && radarr.enable) ''CHECK PROCESS radarr MATCHING "${storeRegex}.*radarr"''
        + lib.optionalString (radicale.monitor.enable && radicale.enable) ''CHECK PROCESS radicale MATCHING "${storeRegex}.*radicale"''
        + lib.optionalString (rustypaste.monitor.enable && rustypaste.enable) ''CHECK PROCESS rustypaste MATCHING "${storeRegex}.*rustypaste"''
        + lib.optionalString (sonarr.monitor.enable && sonarr.enable) ''CHECK PROCESS sonarr MATCHING "${storeRegex}.*sonarr"''
        + lib.optionalString (syncthing.monitor.enable && syncthing.enable) ''CHECK PROCESS syncthing MATCHING "${storeRegex}.*syncthing"''
        + lib.optionalString (tandoor.monitor.enable && tandoor.enable) ''CHECK PROCESS tandoor MATCHING "${storeRegex}.*gunicorn"'';
    };
  };
}
