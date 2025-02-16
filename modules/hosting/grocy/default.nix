{ lib, config, ... }: 
let
  cfg = config.modules.services.grocy;
in {
  options.modules.services.grocy = {
    enable = lib.mkEnableOption " grocy";
    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "Port for the nginx vHost to run on";
    };
    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
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
    services.nginx.virtualHosts.${config.services.grocy.hostName}.listen = [{
      addr = cfg.address;
      port = cfg.port;
    }];

  };
}
