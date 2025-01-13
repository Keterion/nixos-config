{ ... }: {
  services.syncthing = {
    enable = true;
    user = "etherion";
    dataDir = "/home/etherion";
    configDir = "/home/etherion/.config/syncthing/";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
	"SM-A715F" = {
	  id = "EYGP7X5-ZWPOV75-56KHCCW-YVMQIUA-MJVRGDG-JG2JJKG-ECKDJRE-VKXI3AV";
	};
	"Pixel 8 Pro" = {
	  id = "G26A64R-3SEODCY-BWZH3NK-A4DG6HA-BIKSE6Z-ODMGJFS-7ALX4EC-ZL7UVQV";
	};
	"Main" = {
	  id = "36BQPFN-D2MWBII-N7TYIGO-EKBAGLD-OGZWRRE-CKBKTCF-HCVHHE2-Q3D4DAF";
	};
      };
      folders = {
	"ycnaw-dc4ex" = {
	  label = "Music";
	  path = "/home/etherion/Music/songs";
	  devices = [ "SM-A715F" "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"rcnav-y6mqj" = {
	  label = "Obsidian";
	  path = "/home/etherion/Documents/Obsidian";
	  devices = [ "SM-A715F" "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"t7ez7-ezwxh" = {
	  label = "Passwords";
	  path = "/home/etherion/Documents/Passwords";
	  devices = [ "SM-A715F" "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"m3xdc-10b3a" = {
	  label = "Sync";
	  path = "/home/etherion/Sync";
	  devices = [ "SM-A715F" "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"wrgiw-yeh7e" = {
	  label = "DCIM";
	  path = "/mnt/HDD/Bilder/DCIM";
	  devices = [ "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
	"wrfwn-ejec3" = {
	  label = "Pictures";
	  path = "/mnt/HDD/Bilder/Pictures/";
	  devices = [ "Pixel 8 Pro" ];
	  syncXattrs = true;
	  sendXattrs = true;
	};
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
} 
