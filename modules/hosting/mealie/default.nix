{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hosting.mealie;
in {
  options.hosting.mealie = {
    enable = lib.mkEnableOption "mealie";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "WebUI port";
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
    hosting.enabledServices = ["mealie"];
    services.mealie = {
      #enable = builtins.trace "Mealie is currently broken" false;
      enable = true;
      port = cfg.port;
      listenAddress = cfg.ip;
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
