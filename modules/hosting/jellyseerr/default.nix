{
  config,
  lib,
  ...
}: let
  cfg = config.hosting.jellyseerr;
in {
  options.hosting.jellyseerr = {
    enable = lib.mkEnableOption "jellyseerr";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "WebUI port";
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["jellyseerr"];
    services.seerr = {
      enable = true;
      port = cfg.port;
      openFirewall = cfg.openFirewall;
    };
    systemd.services.seerr = lib.mkIf config.apps.mullvad-vpn.enable {
      after = ["mullvad-daemon.service"];
      requires = ["mullvad-daemon.service"];
    };
  };
}
