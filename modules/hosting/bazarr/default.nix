{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.bazarr;
in {
  options.hosting.bazarr = {
    enable = lib.mkEnableOption "bazarr for subtitles";
    group = lib.mkOption {
      default = config.hosting.defaultGroup;
      type = lib.types.str;
      description = "Group for bazarr to run under";
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 6767;
      description = "Port for the web interface";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
  };

  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      group = cfg.group;
      listenPort = cfg.port;
      openFirewall = cfg.openFirewall;
      user = "bazarr";
    };
  };
}
