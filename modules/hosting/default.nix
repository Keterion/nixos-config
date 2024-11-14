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
    ./webserver
    ./dns
    ./radicale
  ];
  options.modules.hosting = {
    netfligs.enable = lib.mkEnableOption "the full netfligs suite";
    openFirewall = lib.mkEnableOption "the open firewall for remote access";
    commonGroup = {
      enable = lib.mkOption {
	type = lib.types.bool;
	default = false;
	description = "Whether to use a common group for the servers";
      };
      name = lib.mkOption {
	type = lib.types.str;
	default = "server";
	description = "The group name to use for the shared group";
      };
    };
  };
  config = {
    users.groups.${cfg.commonGroup.name} = {};
    modules.services = lib.mkIf cfg.netfligs.enable {
      bazarr.enable = lib.mkDefault true;
      sonarr = {
        enable = true;
      };
      radarr.enable = true;
      prowlarr.enable = true;
      calibre = {
        enable = lib.mkDefault true;
	web = {
	  enable = lib.mkDefault true;
	  allowUploads = true;
	  enableBookConversion = true;
	};
	server = {
	  enable = lib.mkDefault true;
	  openFirewall = lib.mkDefault cfg.openFirewall; # need to add this here because the calibre-server module doesn't have the setting
	};
      };
      radicale.enable = lib.mkDefault true;
      blocky.enable = lib.mkDefault true;
    };
  };
}
