{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.calibre.server;
in {
  options.hosting.calibre.server = {
    enable = lib.mkEnableOption "the calibre-server service";
    libraries = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [
        "/var/lib/calibre-server"
      ];
      description = "Libraries for the server, each one has to be initialized";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8080;
      description = "Port for calibre-server to run on";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
      description = "Group for calibre-server to run under";
    };
  };

  config = lib.mkIf cfg.enable {
    services.calibre-server = {
      enable = true;
      group = cfg.group;
      user = "calibre-server";
      libraries = cfg.libraries;
      port = cfg.port;
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      cfg.port
    ];
    hosting.boundPorts."${toString cfg.port}" = "calibre-server";
    #home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [
    #  {
    #    name = "Calibre-Server";
    #    url = "http://${config.hosting.ip}:${toString cfg.port}";
    #    tags = ["hosted"];
    #  }
    #];
  };
}
