{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/preconf/syncthing.nix
    ../../modules/system/wm
    ../../vars/theming
    ../../modules/system/terminal
    ../../modules/system/tools
    ../../modules/apps/base.nix
    ../../modules/privacy
    ../../modules/development
  ];
  nix.settings.trusted-users = [ "@wheel" ];

  programs.adb.enable = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  vars.theming.colorscheme = "tokyonight-moon";
  vars.globals = {
    defaultUser = {
      name = "etherion";
      extraGroups = [ "adbusers" ];
    };
    keyboard = {
      layout = "us";
      variant = "dvorak";
    };
  };

  services.xserver.enable = true;
  #services.displayManager.sddm = {
  #  enable = true;
  #  wayland.enable = true;
  #};
  services.xserver.displayManager.lightdm.enable = true;
  system.wm.plasma.enable = true;
  system.wm.hyprland = {
    enable = true;
    autologin = true;
  };
  system.terminal.kitty.enable = true;
  system.tools.nh = {
    enable = true;
    clean = true;
  };
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
  #programs.adb.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [ pkgs.hplip ];

  modules = {
    apps = {
      office.enable = true;
      git.enable = true;
      cli.network.enable = true;
      games.minecraft.enable = true;
    };
    development = {
      influences = {
	editor.enable = true;
	packageInstall = true;
      }; 
      rust.enable = true;
      nix.enable = true;
      typst.enable = true;
    };
  };
  
}
