{ config, lib, myUtils, ... }: {
  options.system.firewall = {
    enable = myUtils.mkEnabledOption "the firewall";
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
