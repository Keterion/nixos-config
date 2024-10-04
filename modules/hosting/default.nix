{ lib, pkgs, config, ... }:
let
  cfg = config.modules.hosting;
in {
  imports = [
    ./bazarr
    ./sonarr
    ./radarr
    ./prowlarr
    ./calibre
  ];
  options.modules.hosting = {
    netfligs.enable = lib.mkEnableOption "the full netfligs suite";
    openFirewall = lib.mkEnableOption "the open firewall for remote access";
  };
  config = lib.mkIf cfg.enable {
    modules.services = {
      bazarr.enable = true;
      sonarr = {
        enable = true;
      };
      radarr.enable = true;
      prowlarr.enable = true;
      calibre = {
        enable = true;
	web = {
	  enable = true;
	  libraryPath = null;
	  allowUploads = true;
	  enableBookConversion = true;
	};
      };
    };
  };
}
