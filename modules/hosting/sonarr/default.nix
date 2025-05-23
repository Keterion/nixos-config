{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.sonarr;
in {
  options.hosting.sonarr = {
    enable = lib.mkEnableOption "sonarr";
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
      default = 8989;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["sonarr"];
    services.sonarr = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
  };
}
