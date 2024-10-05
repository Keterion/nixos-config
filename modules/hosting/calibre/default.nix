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
    };
  };
  config = {
    environment.systemPackages = lib.optionals cfg.enable [
      pkgs.calibre
    ];
    services.calibre-web = lib.mkIf cfg.web.enable {
      enable = true;
      openFirewall = lib.mkDefault config.modules.hosting.openFirewall;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      user = "calibre-web";
      options = {
	calibreLibrary = cfg.web.libraryPath;
	enableBookConversion = cfg.web.enableBookConversion;
	enableBookUploading = cfg.web.allowUploads;
      };
    };
    services.calibre-server = lib.mkIf cfg.server.enable {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      user = "calibre-server";
      libraries = cfg.server.libraries;
    };
    networking.firewall = lib.mkIf cfg.server.openFirewall {
      allowedTCPPorts = [ config.services.calibre-server.port ];
    };
  };
}
