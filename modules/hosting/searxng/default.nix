{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.searxng;
in {
  options.hosting.searxng = {
    enable = lib.mkEnableOption "searxng";
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
    services.searx = {
      enable = true;
      settings = {
        general = {
          debug = false;
          instance_name = "searxng";
        };
        server = {
          port = cfg.port;
          bind_address = cfg.ip;
          base_url = lib.optionalString cfg.proxy.enable config.hosting.proxy_base;
        };
        outgoing = {
          request_timeout = 2;
        };
      };
    };
  };
}
