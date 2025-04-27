{ ... }: {
  imports = [ 
    ../modules/system
    ../modules/apps
    ../variables
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS =	"de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = 	"de_DE.UTF-8";
    LC_MONETARY = 	"de_DE.UTF-8";
    LC_NAME = 		"de_DE.UTF-8";
    LC_NUMERIC = 	"de_DE.UTF-8";
    LC_PAPER = 		"de_DE.UTF-8";
    LC_TELEPHONE = 	"de_DE.UTF-8";
    LC_TIME = 		"de_DE.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;
  
  system.stateVersion = "24.05";
}
