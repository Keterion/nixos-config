{ lib, config, ... }:
let
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
  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      port = cfg.port;
    };
  };
}
