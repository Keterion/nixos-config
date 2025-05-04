{ lib, config, ... }:
let
  cfg = config.hosting.blocky;
in
{
  options.hosting.blocky = {
    enable = lib.mkEnableOption "blocky, a fast and lightweight DNS proxy as ad-blocker for local network with many features";
  };
  config = lib.mkIf cfg.blocky.enable {
    services.blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = [
	  "9.9.9.9"
	  "149.112.112.112"
	  "https://one.one.one.one/dns-query"
	];
	blocking = {
	  blackLists = {
	    ads = [
	      "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
	      "https://gist.githubusercontent.com/anthony-wang/943e08bc83759e1dbb8745819f4b3eca/raw/52d8958277f0737e29048034ccff2cea6fde93d9/spotify-hosts.txt"
	      #"https://gist.github.com/anthony-wang/943e08bc83759e1dbb8745819f4b3eca/"
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
