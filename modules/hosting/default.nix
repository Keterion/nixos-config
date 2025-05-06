{
  lib,
  config,
  ...
}: let
  cfg = config.hosting;
in {
  imports = [
    ./bazarr
    ./calibre
    ./dns
    ./grocy
    ./jellyfin
    ./prowlarr
    ./qbittorrent
    ./radarr
    ./radicale
    ./sonarr
    ./syncthing
    ./tandoor
  ];

  options.hosting = {
    defaultGroup = lib.mkOption {
      type = lib.types.str;
      default = "server";
      description = "Default group to use for all services, shouldn't exist anywhere else";
    };
    openFirewall = lib.mkEnableOption "open Firewall for all services";
    ip = lib.mkOption {
      type = lib.types.str;
      default = "::1";
      description = "IP to use";
    };
  };

  config = {
    users.groups.${cfg.defaultGroup} = {
      gid = 990;
      name = "${cfg.defaultGroup}";
    };

    home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [
      {
        name = "Toolbar";
        toolbar = true;
        bookmarks = [
          {
            name = "Hosted"; # auto-add to this group
            toolbar = false;
            bookmarks =
              lib.optionals cfg.bazarr.enable [
                {
                  name = "Bazarr";
                  url = "http://${config.hosting.ip}:${toString cfg.bazarr.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.calibre.server.enable [
                {
                  name = "Calibre-Server";
                  url = "http://${config.hosting.ip}:${toString cfg.calibre.server.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.calibre.web.enable [
                {
                  name = "Calibre-Web";
                  url = "http://${config.hosting.ip}:${toString cfg.calibre.web.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.grocy.enable [
                {
                  name = "Grocy";
                  url = "http://${cfg.grocy.ip}:${toString cfg.grocy.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.jellyfin.enable [
                {
                  name = "Jellyfin";
                  url = "http://${config.hosting.ip}:8096";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.prowlarr.enable [
                {
                  name = "Prowlarr";
                  url = "http://${config.hosting.ip}:${toString cfg.prowlarr.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.qbittorrent.enable [
                {
                  name = "qBittorrent";
                  url = "http://${config.hosting.ip}:${toString cfg.qbittorrent.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.radarr.enable [
                {
                  name = "Radarr";
                  url = "http://${config.hosting.ip}:${toString cfg.radarr.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.radicale.enable [
                {
                  name = "Radicale";
                  url = "http://${cfg.radicale.ip}:${toString cfg.radicale.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.sonarr.enable [
                {
                  name = "Sonarr";
                  url = "http://${config.hosting.ip}:${toString cfg.sonarr.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.tandoor.enable [
                {
                  name = "Syncthing";
                  url = "http://${cfg.syncthing.ip}:${toString cfg.syncthing.port}";
                  tags = ["hosted"];
                }
              ]
              ++ lib.optionals cfg.tandoor.enable [
                {
                  name = "Tandoor";
                  url = "http://${cfg.tandoor.ip}:${toString cfg.tandoor.port}";
                  tags = ["hosted"];
                }
              ];
          }
        ];
      }
    ];
  };
}
