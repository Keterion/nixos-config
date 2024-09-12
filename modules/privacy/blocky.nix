{ lib, pkgs, config, ... }:
let
  cfg = config.modules.privacy;
in
{
  options.modules.privacy.blocky = {
    enable = mkEnableOption "the blocky DNS proxy and ad-blocker";
  };
  config = lib.mkIf cfg.blocky.enable {
    services.blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = [
	  "9.9.9.9"
	];
	blocking = {
	  blacklists = {
	    ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
	  };
	  clientGroupsBlock = {
	    default = [ "ads" ];
	  };
	};
      };
    };
  };
}
