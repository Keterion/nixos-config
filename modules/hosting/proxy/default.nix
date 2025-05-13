{
  config,
  lib,
  ...
}: let
  cfg = config.hosting.proxy;
in {
  options.hosting.proxy = {
    enable = lib.mkEnableOption "a proxy for all other webuis";
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."main" = {
      locations = {
        "/" = {
          proxyPass = "http://${config.hosting.ip}:8085";
        };
      };
    };
  };
}
