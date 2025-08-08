{
  lib,
  config,
  pkgs,
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
      content = ''
        SYNC_MASTER_SECRET=${config.sops.placeholder."service/firefox-syncserver/master"}
      '';
    };

    services.firefox-syncserver = {
      enable = true;
      database = {
        createLocally = true;
        host = "${cfg.ip}";
        name = "firefox_syncserver";
      };
      settings = {
        port = cfg.port;
        tokenserver.enable = true;
      };
      secrets = config.sops.templates."firefox-syncserver.conf".path;
    };
    services.mysql.package = pkgs.mariadb;
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];
  };
}
