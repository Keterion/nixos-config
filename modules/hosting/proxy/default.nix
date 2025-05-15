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
    services.nginx.enable = true;
    services.nginx.virtualHosts."main".locations = lib.listToAttrs (map (
        service: {
          name = "/${service}/";
          value = lib.mkIf config.hosting.${service}.proxy.enable {
            proxyPass = "http://${config.hosting.ip}:${toString config.hosting.${service}.port}/";
          };
        }
      )
      config.hosting.enabledServices);
  };
}
