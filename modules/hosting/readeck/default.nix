{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.readeck;
in {
  options.hosting.readeck = {
    enable = lib.mkEnableOption "readeck.";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 9000;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/readeck";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "readeck";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["readeck"];
    sops.secrets."service/readeck/secret_key" = {
      owner = cfg.user;
      group = cfg.group;
    };
    sops.templates."readeck.env".content = ''
      READECK_SECRET_KEY=${config.sops.placeholder."service/readeck/secret_key"}
    '';

    services.readeck = {
      enable = true;
      environmentFile = config.sops.templates."readeck.env".path;
      settings = {
        main = {
          log_level = "info";
          data_directory = cfg.dataDir;
        };
        server = {
          host = cfg.ip;
          port = cfg.port;
        };
      };
    };

    users.users = lib.mkIf (cfg.user == "readeck") {
      readeck = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = false;
        description = "Readeck Daemon user";
        isSystemUser = true;
      };
    };
    users.groups =
      lib.mkIf (cfg.group == "readeck") {readeck = {gid = null;};};

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
