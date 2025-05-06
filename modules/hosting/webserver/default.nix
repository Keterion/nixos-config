{
  lib,
  config,
  ...
}: let
  cfg = config.modules.hosting.webserver;
in {
  options.modules.hosting.webserver = {
    enable = lib.mkEnableOption "the static-web-server service";
    port = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.u16;
      default = 8787;
      description = "Port for the webserver to listen on";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.hosting.openFirewall;
      description = "Whether to allow external access to the webserver";
    };
    #root = lib.mkOption {
    #  type = lib.types.path;
    #  description = "The location of files to serve. Must be set before starting the webserver";
    #  default = /etc/webserver/;
    #};
    servicesPage = {
      enable = lib.mkEnableOption "auto-generated page for services";
      name = lib.mkOption {
        type = lib.types.str;
        default = "services.html";
        description = "Name of the file";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc = lib.mkIf cfg.servicesPage.enable {
      "webserver/${cfg.servicesPage.name}".text = ''             
        <!DOCTYPE html>
         <html lang="en">
           <head>
             <meta charset="UTF-8">
             <meta name="viewport" content="width=device-width, initial-scale=1.0">
             <meta http-equiv="X-UA-Compatible" content="ie=edge">
             <title>Enabled Services</title>
             <link rel="stylesheet" href="style.css">
           </head>
           <body>
             <script src="index.js"></script>
             $content
           </body>
         </html>''; # TODO
    };
    services.static-web-server = {
      enable = true;
      listen = "[::]:${toString cfg.port}";
      root = "/etc/webserver";
      configuration = {
        general = {
          log-level = "error";

          compression = true;
          compression-level = "default";

          page404 = "./404.html";
          page50x = "./50x.html";

          http2 = false;
          http2-tls-cert = "";
          http2-tls-key = "";
          https-redirect = false;
          https-redirect-host = "localhost";
          https-redirect-from-port = 80;
          https-redirect-from-hosts = "localhost";

          #security-headers = true;
          # cors-allow-origins = ""

          directory-listing = false;

          directory-listing-order = 1;

          directory-listing-format = "html";

          # basic-auth = ""
          # fd = ""

          threads-multiplier = 1;

          grace-period = 0;

          #page-fallback = "" # page fallback for 404s

          log-remote-address = false;

          redirect-trailing-slash = true;

          health = true;

          compression-static = true;

          # Maintenance mode
          maintenance-mode = false;
          # maintenance-mode-status = 503;
          # maintenance-mode-file = "./maintenance.html";
        };
      };
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      "${cfg.port}"
    ];
  };
}
