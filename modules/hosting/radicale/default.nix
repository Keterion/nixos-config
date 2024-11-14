{lib, pkgs, config, ...}:
let
  cfg = config.modules.services.radicale;
in {
  options.modules.services.radicale = {
    enable = lib.mkEnableOption "the radicale WebDav and CalDav server";
  };
  config = lib.mkIf cfg.enable {
    environment.etc = {
      "radicale/user".source = ./user;
    };
    services.radicale = {
      enable = true;
      #settings.server.hosts = [ "0.0.0.0:5232" ];
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
  };
}
