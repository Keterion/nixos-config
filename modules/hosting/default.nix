{ lib, config, ... }:
let
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
  };
}
