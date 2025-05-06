{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.grocy;
in {
  options.hosting.grocy = {
    enable = lib.mkEnableOption " grocy";
    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "Port for the nginx vHost to run on";
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to open the grocy port in the firewall";
      default = config.hosting.openFirewall;
    };
  };

  config = lib.mkIf cfg.enable {
    services.grocy = {
      enable = true;
      hostName = "grocy";
      nginx.enableSSL = false;
      settings = {
        culture = "en";
        currency = "EUR";
        calendar.firstDayOfWeek = 1;
      };
    };
    services.nginx.virtualHosts.${config.services.grocy.hostName}.listen = [
      {
        addr = cfg.address;
        port = cfg.port;
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];
    #home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [
    #  {
    #    name = "Grocy";
    #    url = "http://${cfg.ip}:${toString cfg.port}";
    #    tags = ["hosted"];
    #  }
    #];
  };
}
