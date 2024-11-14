{lib, pkgs, config, ...}:
let
  cfg = config.modules.services.radicale;
in {
  options.modules.services.radicale = {
    enable = lib.mkEnableOption "the radicale WebDav and CalDav server";
  };
  config = lib.mkIf cfg.enable {
    services.radicale = {
      enable = true;
      rights = {
	root = {
	  user = ".+";
	  collection = "";
	  permissions = "R";
	};
	calendars = {
	  user = ".+";
	  collection = "{user}/[^/]+";
	  permissions = "rw";
	};
      };
    };
  };
}
