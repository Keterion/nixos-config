{ pkgs, config, lib, ...}:
{
  options.modules.system.wm.hyprland = {
    enable = lib.mkEnableOption "hyprland and utils";
    autologin = lib.mkEnableOption "automatic login into hyprland";
  };

  config = lib.mkIf config.modules.system.wm.hyprland.enable {
    services.displayManager = lib.mkIf config.modules.system.wm.hyprland.autologin {
      autoLogin = {
        enable = true;
        user = "etherion";
      };
      defaultSession = "hyprland";
    };

    services.gnome.gnome-keyring.enable = true;
    services.xserver.enable = true;
    services.udisks2.enable = true;
    services.gvfs.enable = true;

    programs.dconf.enable = true;
    security.polkit.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    
    programs.hyprland.enable = true;

    home-manager.users."etherion" = {
      imports = [
        ./hyprland.nix
	../../screenlocker/swaylock.nix
      ];
      home.packages = with pkgs; [
        swaybg
	clipman
	wl-clipboard
	polkit_gnome
	#gnome-keyring
	ags
      ];
    };
  };
}
