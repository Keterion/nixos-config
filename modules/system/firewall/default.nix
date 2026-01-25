{
  config,
  lib,
  myUtils,
  ...
}: {
  options.sys.firewall = {
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
      enable = config.sys.firewall.enable;
      allowedTCPPorts = config.sys.firewall.allowedTCPPorts;
      allowedUDPPorts = config.sys.firewall.allowedUDPPorts;
    };
  };
}
