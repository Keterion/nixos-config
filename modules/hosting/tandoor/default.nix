{ lib, config, pkgs, ... }:
let
  cfg = config.modules.services.tandoor;
in {
  options.modules.services.tandoor = {
    address = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Web interface address";
    };
    enable = lib.mkEnableOption "tandoor-recipes recipe manager";
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8080;
      description = "Web interface port";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.hosting.openFirewall;
      description = "Whether to open a port for tandoor-recipes in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tandoor-recipes = {
      enable = true;
      address = cfg.address;
      port = cfg.port;
      package = pkgs.tandoor-recipes;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
