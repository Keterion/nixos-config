{ osConfig, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    plugins = [];

    settings = {
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
	  "col.active_border" = "rgb(${osConfig.system.colors.magenta})";
	  "col.inactive_border" = "rgb(${osConfig.system.colors.blue1})";
          env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GDM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
	    "NVD_BACKEND,direct" # va-api hwaccel for nvidia
	    "ELECTRON_OZONE_PLATFORM_HINT,auto" # Flickering Electron/CEF apps
          ];
        };
	decoration = {
	};
	cursor.no_hardware_cursors = true;
        monitor = [
	  "DP-1, 2560x1920@144, 0x0, 1"
	  "HDMI-A-1, 1920x1080@59.999, 2560x0, 1"
	  "Unknown-1, disable"
        ];
	
	"$mod" = "SUPER";
	"$launchMod" = "SUPER";
	"$windowMod" = "SUPER_SHIFT";
	"$systemMod" = "SUPER_ALT";

	"$up" = "up";
	"$down" = "down";
	"$left" = "left";
	"$right" = "right";

	bind = [
	  "$launchMod, R, exec, exec $(${osConfig.system.runner.command})"
	  "$launchMod, E, exec, dolphin" #Filemanager thingy
	  "$launchMod, Return, exec, kitty" #terminal thingy
	  
	  "$windowMod, C, killactive"
	  "$windowMod, F, fullscreen"

	  "$systemMod, E, exit,"
	  "$systemMod, P, exec, systemctl poweroff"
	  "$systemMod, R, exec, systemctl reboot"
	  "$systemMod, H, exec, hyprctl reload"
	  "$systemMod, L, exec, ${osConfig.system.screenlocker.command}"
	  "$systemMod, S, exec, ${osConfig.system.screenlocker.command} & systemctl suspend"


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

	  ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.5"
	  ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.5"
	  ", XF86AudioMute, exec, pamixer -t"
	  ", XF86AudioPlay, exec, playerctl play-pause"
	  ", XF86AudioNext, exec, playerctl next"
	  ", XF86AudioPrev, exec, playerctl previous"
	  ", XF86AudioMicMute, exec, wpctl set-mute 48 toggle"
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
	  "workspace 2, ^(firefox)"
	  "workspace 2, (cord)$"
	  "workspace 3, ^(steam)$"
	  "idleinhibit focus, class:(com.github.iwalton3.jellyfin-media-player)"
	  "suppressevent activatefocus, class:^(steam),title:^(notificationtoasts.*)"
	];
	exec-once = [
	  "waybar"
	];
    };
  };
}
