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
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;

      #services.nginx.virtualHosts."server".locations."/syncthing".proxyPass = "http://127.0.0.1:8384";
      virtualHosts."server" = {
        extraConfig = ''
          proxy_buffering off;
        '';
        #enableACME = true;
        #forceSSL = true;
        locations = lib.listToAttrs (map (
            service: {
              name = "/${service}/";
              value = lib.mkIf config.hosting.${service}.proxy.enable {
                proxyPass = "http://${config.hosting.ip}:${toString config.hosting.${service}.port}/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_set_header    Host $host;
                  proxy_set_header    X-Real-IP $remote_addr;
                  proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header    X-Forwarded-Proto $scheme;
                  proxy_set_header    X-Script-Name   /${service};
                  proxy_set_header    X-Scheme        $scheme;
                  proxy_set_header    Upgrade $http_upgrade;
                '';
              };
            }
          )
          config.hosting.enabledServices);
      };
    };
    networking.firewall.allowedTCPPorts = [443 80];
  };
}
