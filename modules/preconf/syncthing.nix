{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "etherion";
    dataDir = "/home/etherion";
    configDir = "/home/etherion/.config/syncthing/";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
	"Phone" = {
	  id = "UTWZ33O-XQ6DVGM-L6PPAV5-ZVFBY2F-LAXFAT7-FQURQ63-FNINBBY-PCLXRQE";
	};
	"Main" = {
	  id = "36BQPFN-D2MWBII-N7TYIGO-EKBAGLD-OGZWRRE-CKBKTCF-HCVHHE2-Q3D4DAF";
	};
      };
      folders = {
	"ycnaw-dc4ex" = {
	  label = "Music";
	  path = "/home/etherion/Music/songs";
	  devices = [ "Phone" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"rcnav-y6mqj" = {
	  label = "Obsidian";
	  path = "/home/etherion/Documents/Obsidian";
	  devices = [ "Phone" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"t7ez7-ezwxh" = {
	  label = "Passwords";
	  path = "/home/etherion/Documents/Passwords";
	  devices = [ "Phone" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"m3xdc-10b3a" = {
	  label = "Sync";
	  path = "/home/etherion/Sync";
	  devices = [ "Phone" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
} 
