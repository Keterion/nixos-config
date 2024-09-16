{ lib, pkgs, config, ... }:
let
  cfg = config.modules.privacy;
in
{
  options.modules.privacy.blocky = {
    enable = lib.mkEnableOption "the blocky DNS proxy and ad-blocker";
  };
  config = lib.mkIf cfg.blocky.enable {
    services.blocky = {
      enable = true;
      package = pkgs.unstable.blocky;
      settings = {
        upstreams.groups.default = [
	  "9.9.9.9"
	];
	blocking = {
	  denylists = {
	    ads = [ 
	      "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
	      #"https://gist.githubusercontent.com/anthony-wang/943e08bc83759e1dbb8745819f4b3eca/raw/52d8958277f0737e29048034ccff2cea6fde93d9/spotify-hosts.txt"
	      "https://gist.github.com/anthony-wang/943e08bc83759e1dbb8745819f4b3eca/"
	    ];
	  };
	  clientGroupsBlock = {
	    default = [ "ads" ];
	  };
	};
      };
    };
  };
}
