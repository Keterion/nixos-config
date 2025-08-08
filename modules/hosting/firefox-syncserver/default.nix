{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.firefox-syncserver;
in {
  options.hosting.firefox-syncserver = {
    enable = lib.mkEnableOption "firefox-syncserver";
    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "${config.services.firefox-syncserver.database.user}";
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
    hosting.enabledServices = ["firefox-syncserver"];

    sops.secrets."service/firefox-syncserver/master" = {};
    sops.templates."firefox-syncserver.conf" = {
      owner = "${cfg.user}";
      content = ''
        SYNC_MASTER_SECRET=${config.sops.placeholder."service/firefox-syncserver/master"}
      '';
    };

    services.firefox-syncserver = {
      enable = true;
      database = {
        createLocally = true;
        host = "${cfg.ip}";
        name = "firefox-syncserver";
        user = "${cfg.user}";
      };
      settings = {
        port = cfg.port;
        tokenserver.enable = true;
      };
      secrets = config.sops.templates."firefox-syncserver.conf".path;
    };
    networking.firewall.openTCPPorts = lib.optionals cfg.openFirewall [builtins.toString cfg.port];
  };
}
