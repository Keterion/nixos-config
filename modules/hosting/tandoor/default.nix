{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.tandoor;
in {
  options.hosting.tandoor = {
    enable = lib.mkEnableOption "tandoor-recipes recipe manager";
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8080;
      description = "Web interface port";
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
      description = "Whether to open a port for tandoor-recipes in the firewall";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
  };

  config = lib.mkIf cfg.enable {
    services.tandoor-recipes = {
      enable = true;
      address = cfg.ip;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];
  };
}
