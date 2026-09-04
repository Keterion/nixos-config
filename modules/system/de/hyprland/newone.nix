{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  colors = osConfig.sys.colors;

  mkMulticall = calls:
    builtins.map (
      args: {
        _args =
          builtins.map (
            arg:
              if builtins.isString arg
              then (lib.mkLuaInline arg)
              else arg
          )
          args;
      }
    )
    calls;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";
    settings = {
      env = mkMulticall ([
          ["\"XDG_SESSION_TYPE\"" "\"wayland\""]
        ]
        ++ lib.optionals osConfig.sys.graphics.nvidia.enable [
          ["\"LIBVA_DRIVER_NAME\"" "\"nvidia\""]
          ["\"GDM_BACKEND\"" "\"nvidia-drm\""]
          ["\"__GLX_VENDOR_LIBRARY_NAME\"" "\"nvidia\""]
          ["\"NVD_BACKEND\"" "\"direct\""] # va-api hwaccel for nvidia
          ["\"ELECTRON_OZONE_PLATFORM_HINT\"" "\"auto\""] # Flickering Electron/CEF apps
        ]);

      config.general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgb(${colors.magenta})";
        "col.inactive_border" = "rgb(${colors.blue1})";
      };

      config.input =
        if osConfig.sys.keyboard.qwerty_dv
        then {
          kb_layout = "us,us";
          kb_variant = "dvorak,";
          kb_options = "compose:ralt,grp:alt_space_toggle";
        }
        else {
          kb_layout = osConfig.sys.keyboard.layout;
          kb_variant = osConfig.sys.keyboard.variant;
          kb_options = "compose:ralt,grp:alt_space_toggle";
        };
      monitor = [
        {
          output = "DP-1";
          mode = "2560x1440@165";
          position = "0x0";
          scale = 1.3333334;
        }
        {
          output = "HDMI-A-1";
          mode = "preferred";
          position = "auto-right";
          scale = 1;
        }
        {
          output = "desc:Dell Inc. DELL P2217 X80N97A80G4I";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
      # cursor.no_hardware_cursors = true;
      config.xwayland.force_zero_scaling = true;

      "mod"._var = "SUPER";
      "launchMod"._var = "SUPER";
      "windowMod"._var = "SUPER + SHIFT";
      "systemMod"._var = "SUPER + ALT";

      #"$up"._var = "up";
      #"$down"._var = "down";
      #"$left"._var = "left";
      #"$right"._var = "right";

      bind = mkMulticall [
        ["launchMod.. \" + R\"" "hl.dsp.exec_cmd('$(${osConfig.sys.runner.command})')"]
        ["launchMod.. \"+ E\"" "hl.dsp.exec_cmd('${pkgs.yazi}/bin/yazi')"]
        ["launchMod.. \"+ Return\"" "hl.dsp.exec_cmd('kitty')"]

        ["windowMod.. \"+ C\"" "hl.dsp.window.close()"]
        ["windowMod.. \"+ F\"" "hl.dsp.window.fullscreen('fullscreen', 'toggle')"]
        ["windowMod.. \"+ Space\"" "hl.dsp.window.float('toggle')"]

        ["systemMod.. \"+ E\"" "hl.dsp.exec_cmd('uwsm stop')"] #this is better than the exit dispatcher?
        ["systemMod.. \"+ P\"" "hl.dsp.exec_cmd('${systemctl} poweroff')"]
        ["systemMod.. \"+ R\"" "hl.dsp.exec_cmd('${systemctl} reboot')"]
        ["systemMod.. \"+ H\"" "hl.dsp.exec_cmd('${pkgs.hyprland}/bin/hyprctl reload')"]
        ["systemMod.. \"+ L\"" "hl.dsp.exec_cmd('${osConfig.sys.screenlocker.command}')"]
        ["systemMod.. \"+ S\"" "hl.dsp.exec_cmd('${systemctl} suspend')"]

        ["mod.. \"+ 1\"" "hl.dsp.focus({workspace = 1;})"]
        ["mod.. \"+ 2\"" "hl.dsp.focus({workspace = 2;})"]
        ["mod.. \"+ 3\"" "hl.dsp.focus({workspace = 3;})"]
        ["mod.. \"+ 4\"" "hl.dsp.focus({workspace = 4;})"]
        ["mod.. \"+ 5\"" "hl.dsp.focus({workspace = 5;})"]
        ["mod.. \"+ 6\"" "hl.dsp.focus({workspace = 6;})"]
        ["mod.. \"+ 7\"" "hl.dsp.focus({workspace = 7;})"]
        ["mod.. \"+ 8\"" "hl.dsp.focus({workspace = 8;})"]
        ["mod.. \"+ 9\"" "hl.dsp.focus({workspace = 9;})"]
        ["mod.. \"+ 0\"" "hl.dsp.focus({workspace = 10;})"]

        ["windowMod.. \"+ h\"" "hl.dsp.focus({ direction = 'l'; })"]
        ["windowMod.. \"+ l\"" "hl.dsp.focus({ direction = 'r'; })"]
        ["windowMod.. \"+ j\"" "hl.dsp.focus({ direction = 'd'; })"]
        ["windowMod.. \"+ k\"" "hl.dsp.focus({ direction = 'u'; })"]

        ["windowMod.. \"+ 1\"" "hl.dsp.window.move({ workspace=1; follow=true; })"]
        ["windowMod.. \"+ 2\"" "hl.dsp.window.move({ workspace=2; follow=true; })"]
        ["windowMod.. \"+ 3\"" "hl.dsp.window.move({ workspace=3; follow=true; })"]
        ["windowMod.. \"+ 4\"" "hl.dsp.window.move({ workspace=4; follow=true; })"]
        ["windowMod.. \"+ 5\"" "hl.dsp.window.move({ workspace=5; follow=true; })"]
        ["windowMod.. \"+ 6\"" "hl.dsp.window.move({ workspace=6; follow=true; })"]
        ["windowMod.. \"+ 7\"" "hl.dsp.window.move({ workspace=7; follow=true; })"]
        ["windowMod.. \"+ 8\"" "hl.dsp.window.move({ workspace=8; follow=true; })"]
        ["windowMod.. \"+ 9\"" "hl.dsp.window.move({ workspace=9; follow=true; })"]
        ["windowMod.. \"+ 0\"" "hl.dsp.window.move({ workspace=0; follow=true; })"]

        ["\"XF86AudioRaiseVolume\"" "hl.dsp.exec_cmd('${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.5')" {repeating = true;}]
        ["\"XF86AudioLowerVolume\"" "hl.dsp.exec_cmd('${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.5')" {repeating = true;}]
        ["\"XF86AudioMute\"" "hl.dsp.exec_cmd('${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle')" {repeating = true;}]
        ["\"XF86AudioPlay\"" "hl.dsp.exec_cmd('${playerctl} play-pause')" {repeating = true;}]
        ["\"XF86AudioNext\"" "hl.dsp.exec_cmd('${playerctl} next')" {repeating = true;}]
        ["\"XF86AudioPrev\"" "hl.dsp.exec_cmd('${playerctl} previous')" {repeating = true;}]
        ["\"XF86AudioMicMute\"" "hl.dsp.exec_cmd('${wpctl} set-mute 48 toggle')" {repeating = true;}]

        ["\"XF86MonBrightnessUp\"" "hl.dsp.exec_cmd('${pkgs.brightnessctl}/bin/brightnessctl set +5%')" {repeating = true;}]
        ["\"XF86MonBrightnessDown\"" "hl.dsp.exec_cmd('${pkgs.brightnessctl}/bin/brightnessctl set -5%')" {repeating = true;}]

        ["mod.. \"+ mouse:272\"" "hl.dsp.window.drag()"]
        ["mod.. \"+ mouse:273\"" "hl.dsp.window.resize()"]
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "DP-1";
          default = true;
        }
        {
          workspace = "2";
          monitor = "HDMI-A-1";
          default = true;
        }
        {
          workspace = "3";
          monitor = "DP-1";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "5";
          monitor = "DP-1";
        }
        {
          workspace = "6";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "7";
          monitor = "DP-1";
        }
        {
          workspace = "8";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "9";
          monitor = "DP-1";
        }
        {
          workspace = "10";
          monitor = "HDMI-A-1";
        }
      ];

      window_rule = [
        {
          match.class = "^(firefox)";
          workspace = "2";
        }
        {
          match.class = "(cord)$";
          workspace = "2";
        }
        {
          match.class = "^(steam)$";
          workspace = "3";
        }
        {
          match.class = "(com.github.iwalton3.jellyfin-media-player)";
          idle_inhibit = "focus";
        }
        {
          match = {
            class = "^(steam)";
            title = "^(notificationtoasts.*)";
          };
          no_initial_focus = true;
        }
      ];

      curve = [
        {
          _args = [
            "workspace_slide"
            {
              type = "bezier";
              points = [[0.4 (-0.05)] [0.43 0.96]];
            }
          ];
        }
      ];
      animation = [
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          bezier = "workspace_slide";
          style = "slidevert";
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lib.mkLuaInline ''
            function()
              hl.exec_cmd("waybar")
            end
          '')
        ];
      };
    };
  };
}
