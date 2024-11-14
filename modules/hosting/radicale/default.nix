{lib, pkgs, config, ...}:
let
  cfg = config.modules.services.radicale;
in {
  options.modules.services.radicale = {
    enable = lib.mkEnableOption "the radicale WebDav and CalDav server";
    openFirewall = lib.mkEnableOption "open firewall ports";
    port = lib.mkOption {
      type = lib.types.ints.u32;
      default = 5232;
      description = "Port to use for the radicale server";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc = {
      "radicale/user".source = ./user;
    };
    services.radicale = {
      enable = true;
      settings.server.hosts = [ "0.0.0.0:${toString cfg.port}" ];
      rights = {
        root = {
          user = ".+";
          collection = "";
          permissions = "R";
        };
        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "rw";
        };
        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RW";
        };
      };
      settings = {
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/user";
          htpasswd_encryption = "autodetect";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
