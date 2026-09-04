{
  config,
  lib,
  ...
}: let
  cfg = config.sys.notifications.mako;
in {
  options.sys.notifications.mako = {
    enable = lib.mkEnableOption "the mako notification daemon";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.sys.users.default.name} = {
      services.mako = {
        enable = true;
        settings = with config.sys.colors; {
          max-history = 5;
          max-visible = 3;
          sort = "-time";
          on-button-left = "invoke-default-action";
          on-button-middle = "dismiss";

          font = "monospace 10";
          text-color = "#${fg}";
          background-color = "#${bg}";
          width = 300;
          height = 100;
          border-size = 2;
          border-color = "#${magenta}";
          border-radius = 0;
          progress-color = "over #${cyan}";
          icons = 1;

          history = 0;
          format = "<b>%a</b>\\n%b";

          text-alignment = "center";
          default-timeout = 1500; # 1.5 seconds
        };
      };
    };
  };
}
