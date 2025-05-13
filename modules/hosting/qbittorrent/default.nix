{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.qbittorrent;
in {
  imports = [
    ./../../packages/qbittorrent-headless # custom qbittorrent service
  ];

  options.hosting.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent as a background service";
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
      default = 8080;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["qbittorrent"];
    services.qbittorrent = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      port = cfg.port;
    };
  };
}
