{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.system.de.hyprland;
in {
  imports = [
  ];
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
              timeout = 330;
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
    wlsunset.enable = lib.mkEnableOption "wlsunset";
    hyprpaper = {
      enable = lib.mkEnableOption "hyprpaper";
      wallhaven.enable = lib.mkEnableOption "wallhaven auto-wallpapers";
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

    #environment.systemPackages = with pkgs; [
    #  playerctl
    #];

    services.gnome.gnome-keyring.enable = cfg.utils.enable;

    xdg.portal = {
      enable = cfg.utils.enable;
      extraPortals = lib.optionals cfg.utils.enable [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    #scripts.api.wallhaven.enable = cfg.hyprpaper.wallhaven.enable;

    home-manager.users.${config.system.users.default.name} = {
      imports = [
        ./hyprland/${cfg.styleProfile}.nix
        ./hyprland/hyprpaper.nix
      ];
      services.hypridle = lib.mkIf cfg.hypridle.enable {
        enable = true;
        settings = cfg.hypridle.settings;
      };
      services.wlsunset = lib.mkIf cfg.wlsunset.enable {
        enable = true;
        systemdTarget = "graphical-session.target";

        latitude = 52;
        longitude = 8.5;

        gamma = 1.0;

        temperature = {
          day = 6500;
          night = 2500;
        };
      };

      wayland.windowManager.hyprland.settings.exec-once = lib.optionals config.system.audio.mpdris.enable [
        "${pkgs.mpdris2}/bin/mpDris2 --host=${config.hosting.mpd.ip} --port ${toString config.hosting.mpd.port}"
      ];
      home.packages = with pkgs;
        lib.optionals cfg.utils.enable [
          clipman
          wl-clipboard
          polkit_gnome
        ];
    };
  };
}
