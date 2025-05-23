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
    ./jellyseerr
    ./monit
    ./mpd
    ./prowlarr
    ./proxy
    ./qbittorrent
    ./radarr
    ./radicale
    ./rustypaste
    ./sonarr
    ./syncthing
    ./tandoor
    ./whisper
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
    monitor = lib.mkEnableOption "monitoring for all services";
    enabledServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
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
            bookmarks = map (service:
              lib.mkIf config.hosting.${service}.proxy.enable {
                name = service;
                url = "http://${cfg.ip}:${toString config.hosting.${service}.port}";
                tags = ["hosted"];
              })
            cfg.enabledServices;
          }
        ];
      }
    ];
  };
}
