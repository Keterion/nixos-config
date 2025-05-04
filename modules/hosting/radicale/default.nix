{ lib, config, ... }:
let
  cfg = config.hosting.radicale;
in {
  options.hosting.radicale = {
    enable = lib.mkEnableOption "radicale for WebDAV and CalDAV";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 5232;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."radicale/user".source = ./user;

    services.radicale = {
      enable = true;
      settings.server.hosts = [ "${cfg.ip}:${cfg.port}" ];

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
      settings.auth = {
	type = "htpasswd";
	htpasswd_filename = "/etc/radicale/user";
	htpasswd_encryption = "autodetect";
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
  };
}
