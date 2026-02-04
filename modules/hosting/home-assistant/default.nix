{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hosting.home-assistant;
in {
  options.hosting.home-assistant = {
    enable = lib.mkEnableOption "home-assistant";
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
      default = 8123;
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
    hosting.enabledServices = ["home-assistant"];
    services.home-assistant = lib.mkMerge [
      {
        enable = true;
        extraComponents = [
          # Needed to complete onboarding
          "analytics"
          "google_translate"
          "met"
          "radio_browser"
          "shopping_list"
          #zlib compression
          "isal"
          "http"
        ];
        config = {
          default_config = {};
        };
      }
      (lib.mkIf
        cfg.proxy.enable
        {
          config.http = {
            trusted_proxies = ["::1" config.hosting.ip];
            use_x_forwarded_for = true;
          };
        })
    ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
