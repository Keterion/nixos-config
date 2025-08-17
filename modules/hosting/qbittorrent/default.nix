{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hosting.qbittorrent;
in {
  options.hosting.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent as a background service";
    vuetorrent.enable = lib.mkEnableOption "vuetorrent as webui frontend";
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
      webuiPort = cfg.port;
      serverConfig = {
        LegalNotice.Accepted = true;
        WebUI = {
          AlternativeUIEnabled = cfg.vuetorrent.enable;
          RootFolder = lib.optionalString cfg.vuetorrent.enable "${pkgs.vuetorrent}/share/vuetorrent";
        };
      };
    };
  };
}
