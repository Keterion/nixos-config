# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/preconf/syncthing.nix
      ../../modules/system/wm
      ../../vars/theming
      ../../modules/system/terminal
      ../../modules/apps/base.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  vars.theming.colorscheme = "tokyonight-moon";

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
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [pkgs.hplip];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.etherion = {
    isNormalUser = true;
    description = "Etherion";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      webcord-vencord
    ];
    shell = pkgs.zsh;
  };
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  #programs.gamescope.enable = true;
  #programs.gamemode.enable = true;

  #programs.steam = { #TODO
  #  enable = true;
  #  extraCompatPackages = [
  #    pkgs.proton-ge-bin
  #  ];
  #  remotePlay.openFirewall = false;
  #  dedicatedServer.openFirewall = true;
  #  gamescopeSession = {
  #    enable = true;
  #    args = [
  #    ];
  #  };
  #};
  #programs.protontricks.enable = true;

  modules.apps.games = {
    steam = {
      enable = true;
      compat = true;
      backup = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
    minecraft.enable = true;
  };
  modules.apps.office.enable = true;

  modules.apps.git = {
    enable = true;
  };

  programs.zsh.enable = true;

  services.syncthing.enable = true;

  fileSystems."/mnt/Games" = {
    device = "dev/disk/by-uuid/3212add8-8af3-46c6-a739-cfc018bd72ac";
    fsType = "ext4";
  };
  boot.initrd.luks.devices.HDD.device = "/dev/disk/by-uuid/0161cbc2-6ac8-42b4-874e-74c95c494aa9";
}
