{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hosting.opencloud;
  settingsFormat = pkgs.formats.yaml {};
in {
  options.hosting.opencloud = {
    enable = lib.mkEnableOption "opencloud";

    user = lib.mkOption {
      type = lib.types.str;
      default = "opencloud";
      description = "User to run opencloud under";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "${config.hosting.defaultGroup}";
    };

    ip = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.hosting.ip}";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 9200;
    };

    settings = {
      extra = lib.mkOption {
        type = lib.types.attrsOf settingsFormat;
        default = {};
      };
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["opencloud"];
    services.opencloud = {
      enable = true;

      user = cfg.user;
      group = cfg.group;

      address = cfg.ip;
      port = cfg.port;

      settings = lib.attrsets.recursiveUpdate {} cfg.settings;
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [cfg.port];
  };
}
