{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.karakeep;
in {
  options.hosting.mealie = {
    enable = lib.mkEnableOption "karakeep";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
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
    hosting.enabledServices = ["karakeep"];
    services.karakeep = {
      enable = true;
      extraEnvironment = {
        PORT = builtins.toString cfg.port;
        LOG_LEVEL = "notice";
        NEXTAUTH_URL = "${cfg.ip}:${builtins.toString cfg.port}";

        OCR_CACHE_DIR = "/tmp/";
        OCR_LANGS = "eng,deu";

        OTEL_TRACING_ENABLED = false;
      };
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
