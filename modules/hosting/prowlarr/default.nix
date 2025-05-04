{ lib, config, ... }:
let
  cfg = config.hosting.prowlarr;
in {
  options.hosting.prowlarr = {
    enable = lib.mkEnableOption "prowlarr";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 9696;
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
    home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [{
      name = "Hosted";
      toolbar = false;
      bookmarks = [{
	name = "Prowlarr";
	url = "${config.hosting.ip}:${toString cfg.port}";
      }];
    }];
  };
}
