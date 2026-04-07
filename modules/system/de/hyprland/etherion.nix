{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in {
  imports = [
    ./hyprpaper.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    plugins = [];

    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgb(${osConfig.sys.colors.magenta})";
        "col.inactive_border" = "rgb(${osConfig.sys.colors.blue1})";
        env =
          [
            "XDG_SESSION_TYPE,wayland"
          ]
          ++ lib.optionals
          osConfig.sys.graphics.nvidia.enable [
            "LIBVA_DRIVER_NAME,nvidia"
            "GDM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct" # va-api hwaccel for nvidia
            "ELECTRON_OZONE_PLATFORM_HINT,auto" # Flickering Electron/CEF apps
          ];
      };
      decoration = {
      };
      input = {
        kb_layout = "us,us";
        kb_variant = "dvorak,";
        kb_options = "compose:ralt,grp:alt_space_toggle";
      };
      cursor.no_hardware_cursors = true;
      monitor = [
        "DP-1, 2560x1440@165, 0x0, 1.3333334"
        "HDMI-A-1, preferred, auto-right, 1"
        "desc:Dell Inc. DELL P2217 X80N97A80G4I, preferred, auto, 1"
        ", preferred, auto, 1"
      ];
      xwayland = {
        force_zero_scaling = true;
      };

      "$mod" = "SUPER";
      "$launchMod" = "SUPER";
      "$windowMod" = "SUPER_SHIFT";
      "$systemMod" = "SUPER_ALT";

      "$up" = "up";
      "$down" = "down";
      "$left" = "left";
      "$right" = "right";

      bind = [
        "$launchMod, R, exec, exec $(${osConfig.sys.runner.command})"
        "$launchMod, E, exec, $TERMINAL -- ${pkgs.yazi}/bin/yazi" #Filemanager thingy
        "$launchMod, Return, exec, $TERMINAL" #terminal thingy

        "$windowMod, C, killactive"
        "$windowMod, F, fullscreen"

        "$systemMod, E, exit,"
        "$systemMod, P, exec, ${systemctl} poweroff"
        "$systemMod, R, exec, ${systemctl} reboot"
        "$systemMod, H, exec, ${pkgs.hyprland}/bin/hyprctl reload"
        "$systemMod, L, exec, ${osConfig.sys.screenlocker.command}"
        "$systemMod, S, exec, ${osConfig.sys.screenlocker.command} & systemctl suspend"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$windowMod, h, movefocus, l"
        "$windowMod, l, movefocus, r"
        "$windowMod, j, movefocus, d"
        "$windowMod, k, movefocus, u"
        #"$windowMod, k, workspace, r-1"
        #"$windowMod, j, workspace, r+1"

        "$windowMod, 1, movetoworkspace, 1"
        "$windowMod, 2, movetoworkspace, 2"
        "$windowMod, 3, movetoworkspace, 3"
        "$windowMod, 4, movetoworkspace, 4"
        "$windowMod, 5, movetoworkspace, 5"
        "$windowMod, 6, movetoworkspace, 6"
        "$windowMod, 7, movetoworkspace, 7"
        "$windowMod, 8, movetoworkspace, 8"
        "$windowMod, 9, movetoworkspace, 9"
        "$windowMod, 0, movetoworkspace, 10"

        "$windowMod, Space, togglefloating, active"

        ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.5"
        ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.5"
        ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, ${playerctl} play-pause"
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPrev, exec, ${playerctl} previous"
        ", XF86AudioMicMute, exec, ${wpctl} set-mute 48 toggle"

        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      workspace = [
        "1, monitor:DP-1"
        "2, monitor:HDMI-A-1"
        "3, monitor:DP-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:DP-1"
        "6, monitor:HDMI-A-1"
        "7, monitor:DP-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:DP-1"
        "10, monitor:HDMI-A-1"
      ];
      bezier = [
        "workspace_slide, 0.4, -0.05, 0.43, 0.96"
      ];
      animation = [
        "workspaces, 1, 3, workspace_slide, slidevert"
      ];
      windowrule = [
        "workspace 2, match:class ^(firefox)"
        "workspace 2, match:class (cord)$"
        "workspace 3, match:class ^(steam)$"
        "idle_inhibit focus, match:class (com.github.iwalton3.jellyfin-media-player)"
        "no_initial_focus on, match:class ^(steam), match:title ^(notificationtoasts.*)"
      ];
      exec-once = [
        "waybar"
      ];
    };
  };
}
