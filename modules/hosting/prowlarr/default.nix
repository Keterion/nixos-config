{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.prowlarr;
in {
  options.hosting.prowlarr = {
    enable = lib.mkEnableOption "prowlarr";
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 9696;
    };
  };

  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings.server.port = cfg.port;
    };
    hosting.boundPorts."${toString cfg.port}" = "prowlarr";
  };
}
