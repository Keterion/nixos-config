{ pkgs, config, lib, ... }:
let
  cfg = config.system.de.hyprland;
in {
  options.system.de.hyprland = {
    enable = lib.mkEnableOption "hyprland.";
    autologin = lib.mkEnableOption "automatic login into hyprland with supported dms";
    utils.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Whether to enable utilities and compatibility packages for a smoother experience";
    };
    styleProfile = lib.mkOption {
      type = lib.types.enum ["etherion"];
      default = "etherion";
      description = "The settings profile to use";
    };
    hypridle = {
      enable = lib.mkEnableOption "hypridle";
      settings = lib.mkOption {
	type = lib.types.attrsOf lib.types.anything;
	description = "Hypridle settings";
	default = {
	  general = {
	    after_sleep_cmd = "hyprctl dispatch dpms on";
	    ignore_dbus_inhibit = false;
	    lock_cmd = "${config.system.screenlocker.command}";
	  };
	  listener = [
	    {
	      timeout = 900;
	      on-timeout = "${config.system.screenlocker.command}";
	    }
	    {
	      timeout = 300;
	      on-timeout = "hyprctl dispatch dpms off";
	      on-resume = "hyprctl dispatch dpms on";
	    }
	  ];
	};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = lib.mkIf cfg.hypridle.enable {
      enable = true;
    };
    services.displayManager = lib.mkIf cfg.autologin {
      autoLogin = {
	enable = true;
	user = config.system.users.default.name;
      };
      defaultSession = "hyprland";
    };

    services.gnome.gnome-keyring.enable = cfg.utils.enable;
    
    xdg.portal = {
      enable = cfg.utils.enable;
      wlr.enable = cfg.utils.enable;
      extraPortals = lib.optionals cfg.utils.enable [ pkgs.xdg-desktop-portal-hyprland ];
    };

    programs.hyprland.enable = true;

    home-manager.users.${config.system.users.default.name} = {
      imports = [
	./hyprland/${cfg.styleProfile}.nix
      ];
      services.hypridle = lib.mkIf cfg.hypridle.enable {
	enable = true;
	settings = cfg.hypridle.settings;
      };
      home.packages = with pkgs; lib.optionals cfg.utils.enable [
	clipman
	wl-clipboard
	polkit_gnome
      ];
    };
  };
}
