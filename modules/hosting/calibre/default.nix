{ lib, pkgs, config, ...}:
let
  cfg = config.modules.services.calibre;
in {
  options.modules.services.calibre = {
    enable = lib.mkEnableOption "the calibre program";
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
      openFirewall = config.modules.hosting.openFirewall;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      user = "calibre-web";
      options = {
	calibreLibrary = cfg.web.libraryPath;
	enableBookConversion = cfg.web.enableBookConversion;
	enableBookUploading = cfg.web.allowUploads;
      };
    };
  };
}
