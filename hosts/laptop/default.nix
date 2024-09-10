{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/preconf/syncthing.nix
  ];

  networking.hostName = "nyx";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "etherion";
  };

  services.desktopManager.plasma6.enable = true;
  programs.hyprland.enable = true;

  services.displayManager.defaultSession = "hyprland";

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };
  
  programs.zsh.enable = true;
  programs.adb.enable = true;

  users.users.etherion = {
    isNormalUser = true;
    description = "Etherion";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];
  
}
