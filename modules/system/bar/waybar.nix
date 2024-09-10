{ config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    #settings = {
    #  mainBar = {
    #    layer = "top";
    #    position = "top";
    #  
    #    modules-left = [ "hyprland/workspaces" ];
    #    modules-center = [ "clock" ];
    #    modules-right = [ "backlight" "battery" "cpu" "pulseaudio" "memory" "network" "temperature"];

    #    "hyprland/workspaces" = {
    #      "persistent-workspaces" = {
    #        "*" = 9;
    #      };
    #    };
    #  };
    #};
  };
}
