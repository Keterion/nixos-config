{ lib, config, ... }:
let
  cfg = config.hosting.sonarr;
in {
  options.hosting.sonarr = {
    enable = lib.mkEnableOption "sonarr";
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
      default = 8989;
    };
  };

  config = lib.mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
    home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [{
      name = "Hosted";
      toolbar = false;
      bookmarks = [{
	name = "Sonarr";
	url = "${config.hosting.ip}:${cfg.port}";
      }];
    }];
  };
}
