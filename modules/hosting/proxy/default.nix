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
    services.nginx.virtualHosts = {
      "monit" = {
        locations = {
          "/monit/" = {
            proxyPass = "http://${config.hosting.ip}:${toString config.hosting.monit.port}/";
          };
        };
      }; # TODO: Add auto-generated virtual hosts for enabled services (basically the monit thing)
    };
  };
}
