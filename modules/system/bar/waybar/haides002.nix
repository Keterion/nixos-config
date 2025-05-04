let
  workspace-icons = {
    "1" = "一";
    "2" = "二";
    "3" = "三";
    "4" = "四";
    "5" = "五";
    "6" = "六";
    "7" = "七";
    "8" = "八";
    "9" = "九";
    "10" = "十";
  };
in {
  enable = true;
  style = ''
    @define-color background #191724;
    @define-color foreground #e0def4;
    @define-color gray #6e6a86;
    @define-color accent #31748f;
    @define-color red #eb6f92;

    * {
      border: none;
      border-radius: 0px;
      font-family: Hack Nerd Font Mono;
      font-weight: 600;
      font-size: 14px;
    }

    #waybar {
    	background-color: alpha(@background, 1.000000);
    	/*background-color: rgba(0,0,0,0);*/
    	padding: 0;
    	margin: 0;
    }


    /*all modules*/
    #workspaces,
    #workspaces button,
    #window,
    #wireplumber,
    #network,
    #mpris,
    #custom-weather,
    #clock,
    #tray,
    #privacy {
    	color: @foreground;
    	background-color: alpha(@background, 0.0);
    	/*background-color: alpha(#282828, 1.000000);*/

    	margin: 0px 0px;
    	padding: 0px 12px;
        border-radius: 8px;
    }


    /*workspaces*/
    #workspaces {
      padding-left: 0px;
      color: @gray;
    }

    #workspaces button {color: @gray;}
    #workspaces button#sway-workspace-1 {border-radius: 0px 8px 8px 0px;}
    #workspaces button.visible {color: @foreground;}
    #workspaces button.focused,
    #workspaces button.active {background-color: @foreground;color: @background;}
    #workspaces button.urgent {color: @red;}


    /*right modules*/
    *.modules-right {
      border-radius: 8px 0px 0px 8px;
      background-color: @foreground;
    }

    #clock {
      border-radius: 8px;
      background-color: @foreground;
    }

    #wireplumber,
    #network,
    #custom-weather,
    #clock,
    #tray,
    #privacy {
      color: @background;
    }

    /*#privacy,
    #tray {
      margin-left: 0;
      margin-right: 0;
    }
    */
  '';
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 25;
      margin = "0, 0, 0, 0";

      modules-left = [
        "sway/workspaces"
        "hyprland/workspaces"

        "mpris"
      ];

      modules-center = [
        "clock"
        "sway/window"
      ];

      modules-right = [
        "wireplumber"
        "network"
        "tray"
        "privacy"
      ];

      "sway/workspaces" = {
        rotate = 0;
        tooltip = false;

        on-click = "exec $LAUNCHER";
        all-outputs = true;
        format = "{icon}";
        format-icons = workspace-icons;
      };
      "hyprland/workspaces" = {
        all-outputs = true;
        on-click = "exec $LAUNCHER";
        rotate = 0;
        tooltip = false;
        format = "{icon}";
        format-icons = workspace-icons;
      };
      "mpris" = {
        rotate = 0;
        tooltip = false;

        format = "{artist} - {title}";
        title-len = 20;
      };

      "sway/window" = {
        tooltip = false;
        rotate = 0;
        all-outputs = true;
      };
      "clock" = {
        rotate = 0;
        tooltip = false;

        format = "{:%H:%M:%S}";
        format-alt = "{:%Y%m%d T%H:%M:%S}";
        interval = 1;
      };

      "wireplumber" = {
        tooltip = false;
        rotate = 0;
        max-volume = 150;
        on-click = "pavucontrol";
        scroll-step = 5;

        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = [
          "󰕿"
          "󰖀"
          "󰕾"
          "󰕾"
        ];
      };
      "network" = {
        rotate = 0;
        tooltip = false;

        family = "ipv4";

        format-disconnected = "Disconnected";
        format = " {ifname} rx:{bandwidthDownBytes} tx:{bandwidthUpBytes}";
        interval = 1;
        on-click = "$TERM nmtui";
      };
      tray = {
        rotate = 0;
        tooltip = false;
        icon-size = 14;
        show-passive-items = true;
        spacing = 4;
      };
      privacy = {
        rotate = 0;
        tooltip = true;

        icon-size = 14;
        icon-spacing = 4;
        transition-duration = 0;
      };
    };
  };
}
