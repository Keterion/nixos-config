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
  };

  config = lib.mkIf cfg.enable {
    services.displayManager = lib.mkIf cfg.autologin {
      autologin = {
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
      home.packages = with pkgs; lib.optionals cfg.utils.enable [
	clipman
	wl-clipboard
	polkit_gnome
      ];
    };
  };
}
