{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.prowlarr;
in {
  options.hosting.prowlarr = {
    enable = lib.mkEnableOption "prowlarr";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 9696;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["prowlarr"];
    services.prowlarr = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
  };
}
