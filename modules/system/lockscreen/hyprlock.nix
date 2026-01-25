{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.sys.screenlocker.hyprlock;
in {
  options.sys.screenlocker.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };
  config = lib.mkIf cfg.enable {
    security.pam.services.hyprlock = {};
    sys.screenlocker = {
      name = "hyprlock";
      command = lib.mkDefault "${pkgs.hyprlock}/bin/hyprlock";
    };

    home-manager.users.${config.sys.users.default.name} = {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
          };
          animations = {
            enabled = true;
            fade_in = {
              duration = 200;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 200;
              bezier = "easeOutQuint";
            };
          };
          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 3;
            }
          ];
          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
            }
          ];
        };
      };
    };
  };
}
