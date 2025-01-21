{ config, lib, ... }: {
  options.system.firewall = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable a firewall";
    };
    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.ints.u32;
      default = [];
      description = "Allowed TCP ports";
    };
    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.ints.u32;
      default = [];
      description = "Allowed UDP Ports";
    };
  };

  config = {
    networking.firewall = {
      enable = config.system.firewall.enable;
      allowedTCPPorts = config.system.firewall.allowedTCPPorts;
      allowedUDPPorts = config.system.firewall.allowedUDPPorts;
    };
  };
}
