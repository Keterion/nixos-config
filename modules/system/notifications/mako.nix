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
    services.mako = {
      enable = true;
      #settings = {};
    };
  };
}
