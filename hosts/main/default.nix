# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/preconf/syncthing.nix
      ../../modules/system/wm
      ../../vars/theming
      ../../modules/system/terminal
      ../../modules/apps/base.nix
      ../../modules/privacy
      ../../modules/hosting
    ];

  nix.settings.trusted-users = [
    "@wheel"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  vars.theming.colorscheme = "tokyonight-moon";
  vars.globals = {
    defaultUser = {
      name = "etherion";
      extraGroups = [] ++ lib.optionals config.modules.hosting.commonGroup.enable [ config.modules.hosting.commonGroup.name ];
    };
    keyboard = {
      layout = "us";
      variant = "";
    };
  };

  #hardware.bluetooth = {
  #  enable = true; # enable Bluetooth support
  #  powerOnBoot = true; #powers up default bluetooth controller on boot
  #};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm = {
  # enable = true;
  # #wayland.enable = true;
  #};
  services.xserver.displayManager.lightdm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  modules.system.wm.plasma.enable = true;

  modules.system.wm.hyprland = {
    enable = true;
    autologin = true;
  };

  modules.system.terminal.kitty.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [pkgs.hplip];

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  modules = {
    apps = {
      games = {
        steam = {
         enable = true;
         compat = true;
         backup = true;
         remotePlay.openFirewall = false;
         dedicatedServer.openFirewall = true;
         gamescopeSession.enable = true;
       };
       minecraft.enable = true;
       osu.enable = true;
       lutris.enable = true;
       epicgames.enable = false;
      };
      office.enable = true;
      git.enable = true;
      cli.network.enable = true;
    };
    privacy.vpn.enable = true;

    hosting = {
      netfligs.enable = true;
      openFirewall = false;
      commonGroup = {
	enable = true;
	name = "server";
      };
      webserver = {
        enable = false;
	root = "/home/etherion/Documents/dev/html/selfhosted"; #TODO
      };
    };
    
    services.calibre = {
      enable = false;
      web = {
        enable = false;
	libraryPath = "/mnt/priv/Media/Library";
	openFirewall = true;
      };
      server = {
        enable = false;
        libraries = [ "/mnt/priv/Media/Library" ];
	openFirewall = true;
      };
    };
  };
  
  programs.zsh.enable = true;

  services.syncthing.enable = true;

  programs.nix-ld.enable = true; #TODO

  fileSystems."/mnt/Games" = {
    device = "dev/disk/by-uuid/3212add8-8af3-46c6-a739-cfc018bd72ac";
    fsType = "ext4";
  };
	
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices.HDD.device = "/dev/disk/by-uuid/0161cbc2-6ac8-42b4-874e-74c95c494aa9";
  fileSystems."/mnt/HDD" = {
    device = "/dev/mapper/HDD";
  };

  boot.initrd.luks.devices.Priv.device = "/dev/disk/by-uuid/ef533879-a0c5-456a-8a91-db761e21ed63";
  fileSystems."/mnt/priv" = {
    device = "/dev/mapper/Priv";
  };
  networking.firewall.allowedTCPPorts = [ 45869 ];
}
