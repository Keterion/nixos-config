{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.syncthing;
in {
  options.hosting.syncthing = {
    enable = lib.mkEnableOption "syncthing";
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "${config.system.users.default.name}";
    };
    port = lib.mkOption {
      default = 8384;
      type = lib.types.ints.u16;
    };
    ip = lib.mkOption {
      default = config.hosting.ip;
      type = lib.types.str;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      group = cfg.group;
      user = cfg.user;
      guiAddress = "${cfg.ip}:${toString cfg.port}";
      openDefaultPorts = cfg.openFirewall; # todo with settings.listenAddresses but too much work rn
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "SM-A715F" = {
            id = "EYGP7X5-ZWPOV75-56KHCCW-YVMQIUA-MJVRGDG-JG2JJKG-ECKDJRE-VKXI3AV";
          };
          "Pixel 8 Pro" = {
            id = "NWVM3BV-2DLYCD2-DD4WMVS-4NDX4O3-NDA2S72-23HYRAU-IASJ3O4-N2ZSUA7";
          };
          "Main" = {
            id = "36BQPFN-D2MWBII-N7TYIGO-EKBAGLD-OGZWRRE-CKBKTCF-HCVHHE2-Q3D4DAF";
          };
          "Laptop" = {
            id = "I64U44B-MRH6RCG-OINE5RT-22DHZ5O-ITXTHOU-DUN5BP2-RQTTYBE-M3QUSAJ";
          };
        };
        folders = {
          "ycnaw-dc4ex" = {
            label = "Music";
            path = "/home/etherion/Music/songs";
            devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
          };
          "rcnav-y6mqj" = {
            label = "Obsidian";
            path = "/home/etherion/Documents/Obsidian";
            devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
            compression = "all";
          };
          "t7ez7-ezwxh" = {
            label = "Passwords";
            path = "/home/etherion/Documents/Passwords";
            devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
          };
          "m3xdc-10b3a" = {
            label = "Sync";
            path = "/home/etherion/Sync";
            devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
          };
          "wrgiw-yeh7e" = {
            label = "DCIM";
            path = "/mnt/HDD/Bilder/DCIM";
            devices = ["Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
          };
          "wrfwn-ejec3" = {
            label = "Pictures";
            path = "/mnt/HDD/Bilder/Pictures/";
            devices = ["Pixel 8 Pro" "Laptop" "Main"];
            syncXattrs = true;
            sendXattrs = true;
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [cfg.port]; # webui also open firewall
  };
}
