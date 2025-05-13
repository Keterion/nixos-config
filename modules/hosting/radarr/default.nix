{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.radarr;
in {
  options.hosting.radarr = {
    enable = lib.mkEnableOption "radarr";
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
      default = 7878;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["radarr"];
    services.radarr = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
  };
}
