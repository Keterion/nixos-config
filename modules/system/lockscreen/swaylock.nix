{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.screenlocker.swaylock;
in {
  options.sys.screenlocker.swaylock = {
    enable = lib.mkEnableOption "swaylock";
  };

  config = lib.mkIf cfg.enable {
    sys.screenlocker = {
      name = "swaylock";
      command = lib.mkDefault "${pkgs.swaylock}/bin/swaylock";
    };

    home-manager.users.${config.sys.users.default.name} = {
      programs.swaylock = {
        enable = true;
        settings = with config.sys.colors; {
          color = "${bg}";
          indicator-idle-visible = true;
          indicator-radius = 150;
          indicator-thickness = 15;

          inside-color = "${bg}";
          inside-clear-color = "${bg}";
          inside-ver-color = "${bg}";
          inside-wrong-color = "${bg}";

          key-hl-color = "${red1}";
          bs-hl-color = "${red2}";

          separator-color = "${bg}";

          line-color = "${bg}";
          line-clear-color = "${yellow}";
          line-caps-lock-color = "${cyan}";
          line-ver-color = "${yellow}";
          line-wrong-color = "${red1}";

          text-clear-color = "${fg}";
          text-ver-color = "${yellow}";
          text-wrong-color = "${red1}";

          ring-color = "${fg_dark}";
          ring-clear-color = "${fg_dark}";
          ring-caps-lock-color = "${fg_dark}";
          ring-ver-color = "${fg_dark}";
          ring-wrong-color = "${fg_dark}";
        };
      };
    };
  };
}
