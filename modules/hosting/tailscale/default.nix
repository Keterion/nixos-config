{
  config,
  lib,
  ...
}: let
  cfg = config.hosting.tailscale;
in {
  options.hosting.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    port = lib.mkOption {
      type = lib.types.port;
      default = 41641;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
      description = "Whether to open a port for tandoor-recipes in the firewall";
    };
    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "tailscale0";
      description = "Tailscale network interface name";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.trustedInterfaces = [cfg.interfaceName];
    networking.firewall.allowedUDPPorts = [cfg.port];

    systemd.services.tailscaled.serviceConfig.Environment = lib.optionals config.sys.network.nftables.enable [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    services.tailscale = {
      enable = true;
      openFirewall = cfg.openFirewall;
      interfaceName = cfg.interfaceName;

      extraUpFlags = [];
      extraSetFlags = [];
      extraDaemonFlags = [];
      disableUpstreamLogging = true;
    };
  };
}
