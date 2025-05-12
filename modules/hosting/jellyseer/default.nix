{
  config,
  lib,
  ...
}: let
  cfg = config.hosting.jellyseer;
in {
  options.hosting.jellyseer = {
    enable = lib.mkEnableOption "jellyseer";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "WebUI port";
    };
  };

  config = lib.mkIf cfg.enable {
    serivces.jellyseer = {
      enable = true;
      port = cfg.port;
      openFirewall = cfg.openFirewall;
    };
  };
}
