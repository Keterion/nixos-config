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
      default = 8888;
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
    hosting.enabledServices = ["searxng"];
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
          #secret_key = builtins.readFile ./.secret;
          secret_key = "abababxyzz";
          base_url = lib.optionalString cfg.proxy.enable "${config.hosting.proxy_base}/searxng";
        };
        outgoing = {
          request_timeout = 2;
        };
      };
    };
  };
}
