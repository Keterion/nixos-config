{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.shiori;
in {
  options.hosting.shiori = {
    enable = lib.mkEnableOption "shiori";
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 1625;
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
    hosting.enabledServices = ["shiori"];

    services.shiori = {
      enable = true;
      port = cfg.port;
      address = cfg.ip;
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
