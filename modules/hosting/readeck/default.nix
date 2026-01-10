{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.readeck;
in {
  options.hosting.mysercive = {
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
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["readeck"];

    services.readeck = {
      enable = true;
      settings = {
        main = {
          log_level = "info";
        };
        server = {
          host = cfg.ip;
          port = cfg.port;
        };
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
