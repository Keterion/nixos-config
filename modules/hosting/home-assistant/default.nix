{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hosting.home-assistant;
in {
  options.hosting.home-assistant = {
    enable = lib.mkEnableOption "home-assistant";
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8123;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Config to merge into services.home-assistant.config";
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["home-assistant"];
    services.home-assistant = lib.mkMerge [
      {
        enable = true;
        extraComponents = [
          # Needed to complete onboarding
          "analytics"
          "google_translate"
          "met"
          "radio_browser"
          "shopping_list"
          #zlib compression
          "isal"

          #"vodafone_station"
          # needed for spook
          #"infrared"
          #"recorder"

          "http"
          "zha"

          "default_config" # doesn't work like this in this case ig??
        ];
        customComponents = with pkgs.home-assistant-custom-components; [
          #circadian_lighting
          #spook
          adaptive_lighting
        ];
        config =
          {
            #default_config = {};
            "automation ui" = "!include automations.yaml";
            "scene ui" = "!include scenes.yaml";
            "script ui" = "!include scripts.yaml";

            #circadian_lighting = {
            #  min_colortemp = 2000;
            #  max_colortemp = 6535;
            #};
            keyboard_remote = let
              keyboard_names = [];
              keyboard_descriptors = ["/dev/input/event0" "/dev/input/event2" "/dev/input/event3"];
            in
              [
                #{
                #    device_descriptor = "/dev/input/event0";
                #    type = "key_down";
                #}
              ]
              ++ map (desc: {
                device_descriptor = desc;
                type = "key_down";
              })
              keyboard_descriptors;
            adaptive_lighting = {
              lights = ["light.innr_1" "light.innr_2" "light.innr_3" "light.innr_4"];
              min_brightness = 45;
              max_brightness = 100;
              min_color_temp = 2000;
              max_color_temp = 6535;
              brightness_mode = "linear";
              sleep_brightness = 1;
              sleep_color_temp = 6000;
              take_over_control = true;
              skip_redundant_commands = true;
            };

            automation = [
              {
                alias = "Keyboard light toggle";
                triggers = [
                  {
                    trigger = "event";
                    event_type = "keyboard_remote_command_received";
                    event_data = {
                      key_code = 1;
                      type = "key_down";
                    };
                  }
                ];
                actions = [
                  {
                    action = "light.toggle";
                    target = {
                      entity_id = "light.lr_ceiling";
                    };
                  }
                ];
              }
            ];
            switch = let
              affected_lights = ["light.innr_1" "light.innr_2" "light.innr_3" "light.innr_4"];
            in [
              #{
              #  platform = "circadian_lighting";
              #  name = "Toggle circadian lighting";
              #  lights_ct = affected_lights;
              #}
            ];
          }
          // cfg.extraConfig;
      }
      (lib.mkIf
        cfg.proxy.enable
        {
          config.http = {
            trusted_proxies = ["::1" config.hosting.ip];
            use_x_forwarded_for = true;
          };
        })
    ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
