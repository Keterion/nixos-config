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
    "10"= "十";
  };
in {
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
    format-icons = workspace-icons; #TODO
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

    format = "<U+F001> {artist} - {title}";
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
    
    format = "<U+F017> {:%H:%M}";
    format-alt = "<U+F133> {:%Y%m%dT%H:%M:%s}";
    interval = 1;
  };


  "wireplumber" = {
    tooltip = false;
    rotate = 0;
    max-volume = 150;
    on-click = "pavucontrol";
    scroll-step = 5;

    format = "{icon} {volume}%";
    format-muted = "<U+F6A9>";
    format-icons = [
      "<U+F026>"
      "<U+F027>"
      "<U+F028>"
      "<U+F028>"
    ];
  };
  "network" = {
    rotate = 0;
    tooltip = false;

    format-disconnected = "Disconnected";
    format-ethernet = "<U+F0A60> {ipaddr}";
    format-linked = "{ifname} (No IP)";
    format-wifi = "rx:{bandwidthDownBytes} tx:{bandwidthUpBytes} ({signalStrength}%) <U+F1EB>";
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
}
