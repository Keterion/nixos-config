{ lib, config, ... }:
let
  cfg = config.hosting.calibre.web;
in {
  options.hosting.calibre.web = {
    enable = lib.mkEnableOption "the calibre-web service";
    libraryPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a Calibre library";
    };
    settings = {
      allowUploads = lib.mkEnableOption "book uploads via web ui";
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8083;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
  };

  config = lib.mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
      group = cfg.group;
      user = "calibre-web";
      options = {
	calibreLibrary = cfg.libraryPath;
	enableBookConversion = true;
	enableBookUploading = cfg.settings.allowUploads;
      };
      listen = {
	port = cfg.port;
	ip = cfg.ip;
      };
      openFirewall = cfg.openFirewall;
    };
    home-manager.users.${config.system.users.default.name}.programs.firefox.profiles."default".bookmarks.settings = [{
      name = "Hosted";
      toolbar = false;
      bookmarks = [{
	name = "Calibre-Web";
	url = "${cfg.ip}:${cfg.port}";
      }];
    }];
  };
}
