{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hosting.restic;
in {
  options.hosting.restic = {
    enable = lib.mkEnableOption "restic";
    port = lib.mkOption {
      type = lib.types.port;
      efault = 8000;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "restic";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "restic";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy = lib.mkEnableOption "proxying";
  };

  config = lib.mkIf cfg.enable {
    services.restic.server = {
      enable = true;
      listenAddress = "${cfg.ip}:${toString cfg.port}";
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
