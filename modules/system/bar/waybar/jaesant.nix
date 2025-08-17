{osConfig, ...}: let
  color = osConfig.system.colors;
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
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "Hack Nerd Font Mono", "Font Awesome 6 Free";
        font-weight: 600;
        font-size: 14px;
      }

      window#waybar {
        background-color: alpha(#${color.bg}, 1);
        padding: 0;
        margin: 0;

        border-radius: 5px;
        border-width: 2px;
        border-style: solid;
        border-color: alpha(#${color.fg_dark}, 1);
      }

      /*all modules*/
      #workspaces,
      #window,
      #wireplumber,
      #network,
      #mpris,
      #custom-vpn,
      #custom-weather,
      #clock,
      #tray,
      #privacy {
        color: #${color.fg};
        background-color: alpha(#${color.bg}, 0.0);

        margin: 4px;
        padding: 0px 8px;

        border-radius: 5px;
        border-width: 2px;
        border-style: solid;
        border-color: alpha(#${color.purple}, 1);
      }

      /*workspaces*/
      #workspaces {
        padding: 0px;
      }

      #workspaces button {
        color: #${color.fg_dark};
        padding: 0px 8px;
        margin: 0px;
      }
      #workspaces button.visible {
        color: #${color.fg};
      }
      #workspaces button.focused,
      #workspaces button.active {
        color: #${color.purple};
      }
      #workspaces button.urgent {
        color: #${color.red2};
      }

      #wokspaces button:hover {
        background: none;
        border: none;
      }
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
          "battery"
          "bluetooth"
          "custom/vpn"
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
          tooltip = true;
          status-icons = {
            playing = "󰏤";
            paused = "󰐊";
            stopped = "󰓛";
          };

          format = "{status_icon} {dynamic}";
          title-len = 25;
          artist-len = 25;
          dynamic-order = [
            "artist"
            "album"
            "title"
          ];
          dynamic-len = 50;
          dynamic-importance-order = [
            "title"
            "artist"
            "album"
          ];
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
        "battery" = {
          bat = "BAT0";
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-charging = "󱐋{icon} {capacity}%";
        };
        "bluetooth" = {
          format = "";
          format-connected = "󰂯 {device_alias}";
          format-connected-battery = "󰂯 {device_alias}: {device_battery_percentage}/100%";

          on-click = "$TERM -c bluetoothctl";
          tooltip = false;
        };
        "network" = {
          rotate = 0;
          tooltip = false;

          family = "ipv4";

          format-disconnected = "Disconnected";
          format = " {ifname} 󰜮{bandwidthDownBytes} 󰜷{bandwidthUpBytes}";
          interval = 1;
          on-click = "$TERM -c nmtui";
        };
        "custom/vpn" = {
          exec = ''
            mullvad status -j |
            jq --unbuffered --compact-output '{ "text": .state, "tooltip": (.details | tojson) }'
          '';
          on-click = ''mullvad reconnect'';

          return-type = "json";
          format = "{text}";
          interval = 5;
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
  };
}
