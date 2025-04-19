{ lib, config, ... }:
let
  cfg = config.services.tandoor;
in {
  options.services.tandoor = {
    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Web interface address";
    };
    enable = lib.mkEnableOption "tandoor-recipes recipe manager";
    port = lib.mkOpion {
      type = lib.types.ints.u16;
      default = 8080;
      description = "Web interface port";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
      description = "Whether to open a port for tandoor-recipes in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tandoor-recipes = {
      enable = true;
      address = cfg.address;
      port = cfg.port;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
