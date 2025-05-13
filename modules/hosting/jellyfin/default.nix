{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.jellyfin;
in {
  options.hosting.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    group = lib.mkOption {
      default = config.hosting.defaultGroup;
      type = lib.types.str;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8096;
    };

    #port = { # no declarative :c
    #  http = lib.mkOption {
    #    default = 8096;
    #    type = lib.types.ints.u16;
    #  };
    #  https = lib.mkOption {
    #    default = 8920;
    #    type = lib.types.ints.u16;
    #  };
    #};
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["jellyfin"];
    services.jellyfin = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      user = "jellyfin";
    };

    #networking.firewall = lib.mkIf cfg.openFirewall {
    #  allowedTCPPorts = [
    #    cfg.port.http
    #    cfg.port.https
    #  ];

    #  allowedUDPPorts = [
    #    1900
    #    7359
    #  ];
    #};
    #home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [
    #  {
    #    name = "Jellyfin";
    #    url = "http://${config.hosting.ip}:8096";
    #    tags = ["hosted"];
    #  }
    #];
  };
}
