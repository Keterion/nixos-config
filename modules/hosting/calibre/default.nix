{ lib, pkgs, config, ...}:
let
  cfg = config.modules.services.calibre;
in {
  options.modules.services.calibre = {
    enable = lib.mkEnableOption "the calibre program";
    server = {
      enable = lib.mkEnableOption "the calibre-server service";
      libraries = lib.mkOption {
        type = lib.types.listOf lib.types.path;
	default = [
	  "/var/lib/calibre-server"
	];
	description = "Libraries for the server, each one has to be initialized";
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
	default = config.modules.hosting.openFirewall;
	description = "the firewall rule for calibre-server";
      };
      port = lib.mkOption {
	type = lib.types.ints.u16;
	default = 8080;
	description = "Port for calibre-server to run on";
      };
    };
    web = {
      enable = lib.mkEnableOption "the calibre-web service";
      libraryPath = lib.mkOption {
	type = lib.types.nullOr lib.types.path;
	default = null;
	description = "Path to Calibre Library";
      };
      allowUploads = lib.mkEnableOption "allow books to be uploaded via Calibre-Web UI";
      enableBookConversion = lib.mkEnableOption "configure path to the calibre's exook-convert in the DB";
      port = lib.mkOption {
	type = lib.types.ints.u16;
	default = 8083;
	description = "Port for calibre-web to use";
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
	default = config.modules.hosting.openFirewall;
	description = "Whether to open ports for calibre-web";
      };
    };
  };
  config = {
    environment.systemPackages = lib.optionals cfg.enable [
      pkgs.calibre
    ];
    services.calibre-web = lib.mkIf cfg.web.enable {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      package = pkgs.stable.calibre-web;
      user = "calibre-web";
      options = {
	calibreLibrary = cfg.web.libraryPath;
	enableBookConversion = cfg.web.enableBookConversion;
	enableBookUploading = cfg.web.allowUploads;
      };
      listen = {
	port = cfg.web.port;
	ip = "192.168.178.69";
      };
      openFirewall = cfg.web.openFirewall;
    };
    services.calibre-server = lib.mkIf cfg.server.enable {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      user = "calibre-server";
      libraries = cfg.server.libraries;
      port = cfg.server.port;
    };
    networking.firewall = lib.mkIf cfg.server.openFirewall {
      allowedTCPPorts = [ config.services.calibre-server.port ]; # calibre-server doesn't have an openFirewall setting
      allowedUDPPorts = [ config.services.calibre-server.port ];

    };
  };
}
