{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.myservice;
in {
  options.hosting.myservice = {
    enable = lib.mkEnableOption "myservice.";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8080;
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
    hosting.enabledServices = ["myservice"];

    services.myservice = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
