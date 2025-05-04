{ lib, config, ... }:
let
  cfg = config.hosting.radarr;
in {
  options.hosting.radarr = {
    enable = lib.mkEnableOption "radarr";
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
      default = 7878;
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      group = cfg.group;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
  };
}
