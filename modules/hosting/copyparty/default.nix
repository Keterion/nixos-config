{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hosting.copyparty;
in {
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  options.hosting.copyparty = {
    enable = lib.mkEnableOption "copyparty";
    port = lib.mkOption {
      type = lib.types.port;
      default = 3210;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "copyparty";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to open the server port in the firewall";
      default = config.hosting.openFirewall;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["copyparty"];
    nixpkgs.overlays = [inputs.copyparty.overlays.default];

    sops.secrets = {
      "service/copyparty/admin_pw" = {
        owner = cfg.user;
        group = cfg.group;
      };
      "service/copyparty/guest_pw" = {
        owner = cfg.user;
        group = cfg.group;
      };
    };

    services.copyparty = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      settings = {
        nc = 6; # number clients

        i = cfg.ip; # ip
        p = cfg.port; # port

        shr = "/shr";

        no-reload = true;
      };
      accounts = {
        admin = {
          passwordFile = config.sops.secrets."service/copyparty/admin_pw".path;
        };

        guest = {
          passwordFile = config.sops.secrets."service/copyparty/guest_pw".path;
        };
      };

      volumes = {
        "/" = {
          path = "/srv/copyparty";
          access = {
            r = "guest";
            w = "*";
            A = "admin";
          };
          flags = {
            #fk = 4;
            e2d = true; # uploads database
            d2t = true; # disable multimedia parsers
          };
        };
      };
    };

    users.users.copyparty = lib.mkIf (cfg.user == "copyparty") {
      # need to do it this way because copyparty only creates the user if the group is also copyparty
      description = "Service user for copyparty";
      group = cfg.group;
      home = "/var/lib/copyparty";
      isSystemUser = true;
    };

    environment.systemPackages = [
      pkgs.copyparty
    ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
