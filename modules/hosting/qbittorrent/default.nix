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

    defaultSavePath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/qBittorrent/qBittorrent/downloads";
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
        Preferences = {
          WebUI = {
            AlternativeUIEnabled = cfg.vuetorrent.enable;
            RootFolder = lib.optionalString cfg.vuetorrent.enable "${pkgs.vuetorrent}/share/vuetorrent";

            Password_PBKDF2 = "@ByteArray(cWg3D/tytOAVBspk0ggCpA==:IIjau2dLjx88IX7n/IajD77bKfFMymqB4Qz+O5IepS+g5LKJuYCq+tXdfiyMH7gkxu6xz+rUCSKIvsLVBL97eA==)";
            Username = "admin";
            Port = cfg.port;
          };
        };
        BitTorrent = {
          Session.Interface = "wg0-mulvad";
          Session.InterfaceName = "wg0-mullvad";
          Session.DefaultSavePath = cfg.defaultSavePath;
          Session.Preallocation = true;
          Session.AddExtensionToIncompleteFiles = true;
        };
        Application = {
          FileLogger.Backup = true;
          FileLogger.Enabled = false;
        };
      };
    };
  };
}
