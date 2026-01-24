{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.syncthing;
  directory = lib.types.submodule {
    options = {
      id = lib.mkOption {
        type = lib.types.str;
        description = "Folder ID used by syncthing";
      };
      label = lib.mkOption {
        type = lib.types.str;
        description = "Label to display directory by";
      };
      devices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of devices by their ID alias to share directory with";
      };
      path = lib.mkOption {
        type = lib.types.str;
        description = "Local path to sync the directory to";
      };
      type = lib.mkOption {
        type = lib.types.enum ["sendreceive" "sendonly" "receiveonly" "receiveencrypted"];
        default = "sendreceive";
      };
    };
  };
in {
  options.hosting.syncthing = {
    enable = lib.mkEnableOption "syncthing";
    config = {
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/syncthing";
      };
      directories = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf directory);
        default = null;
      };
    };
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
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["syncthing"];
    #systemd.services.syncthing = {
    #  after = ["network-online.target"];
    #  wants = ["network-online.target"];
    #};
    services.syncthing = {
      enable = true;
      group = cfg.group;
      user = cfg.user;
      dataDir = cfg.config.dataDir;
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
            id = "M5LR2QO-G7TORHY-FXJUC5S-RWIJFQ7-TO32POZ-5RCF24X-6VSQHAU-AIR7OAD";
          };
          "Main" = {
            id = "36BQPFN-D2MWBII-N7TYIGO-EKBAGLD-OGZWRRE-CKBKTCF-HCVHHE2-Q3D4DAF";
          };
          "Laptop" = {
            id = "I64U44B-MRH6RCG-OINE5RT-22DHZ5O-ITXTHOU-DUN5BP2-RQTTYBE-M3QUSAJ";
          };
          "Hypnos" = {
            id = "ECJ3F7I-GQNSGUE-NPZBQFI-IELDYVF-LUUW2CT-Z5Q2XRP-IWRZYBE-BJ3MZQY";
          };
        };
        folders = builtins.trace "generating directory config for syncthing" (lib.mkIf (cfg.config.directories
            != null)
          (builtins.trace "directories are not null" builtins.listToAttrs
            (lib.map (dir: {
                name = dir.id;
                value = {
                  id = dir.id;
                  label = dir.label;
                  path = dir.path;
                  devices = dir.devices;
                  syncXattrs = true;
                  sendXattrs = true;
                };
              })
              cfg.config.directories)));
        #folders = {
        #  "ycnaw-dc4ex" = {
        #    label = "Music";
        #    path = "/home/${config.system.users.default.name}/Music/songs";
        #    devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #  "rcnav-y6mqj" = {
        #    label = "Obsidian";
        #    path = "/home/${config.system.users.default.name}/Documents/Obsidian";
        #    devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #    compression = "all";
        #  };
        #  "t7ez7-ezwxh" = {
        #    label = "Passwords";
        #    path = "/home/${config.system.users.default.name}/Documents/Passwords";
        #    devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #  "m3xdc-10b3a" = {
        #    label = "Sync";
        #    path = "/home/${config.system.users.default.name}/Sync";
        #    devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #  "wrgiw-yeh7e" = {
        #    label = "DCIM";
        #    path = "/mnt/HDD/Bilder/DCIM";
        #    devices = ["Pixel 8 Pro" "Laptop" "Main"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #  "wrfwn-ejec3" = {
        #    label = "Pictures";
        #    path = "/mnt/HDD/Bilder/Pictures/";
        #    devices = ["Pixel 8 Pro" "Laptop" "Main"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #  "o0gxy-s1rof" = {
        #    label = "Whatsapp Media";
        #    path = "/mnt/HDD/Bilder/Whatsapp Media/";
        #    devices = ["Pixel 8 Pro" "Laptop" "Main" "SM-A715F"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #    type = "receiveonly";
        #  };
        #  "aci0b-orq3j" = {
        #    label = "University";
        #    path = "/home/${config.system.users.default.name}/Documents/School/University/";
        #    devices = ["Pixel 8 Pro" "Laptop" "Main"];
        #    syncXattrs = true;
        #    sendXattrs = true;
        #  };
        #};
      };
    };
    networking.firewall.allowedTCPPorts = [cfg.port]; # webui also open firewall
  };
}
