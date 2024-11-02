{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/privacy
    ../vars/globals
  ];

  modules.privacy.blocky.enable = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  #nix.gc = lib.mkDefault {
  #  automatic = true;
  #  dates = "weekly";
  #  options = "--delete-older-than 7d";
  #};
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    xkb.layout = config.vars.globals.keyboard.layout;
    xkb.variant = config.vars.globals.keyboard.variant;
  };
  users.users.${config.vars.globals.defaultUser.name} = {
    isNormalUser = true;
    description = "Default user";
    extraGroups = [ "networkmanager" "wheel" "audio" ] ++ config.vars.globals.defaultUser.extraGroups;
    packages = [];
    shell = pkgs.zsh;
  };
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  environment.systemPackages = with pkgs; [
    vim
    kitty
    tofi
    firefox
    ffmpeg
    mpv
    nh
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "HeavyData" "JetBrainsMono" ]; })
  ];
  
  programs.bash.shellAliases = {
    nixconf = "sudo nvim /etc/nixos";
  };
  networking.firewall.allowedTCPPorts = [ 1000 ];
  #networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  system.stateVersion = "24.05";
}
