{
  lib,
  myUtils,
  config,
  ...
}: let
  cfg = config.sys.ssh;
in {
  options.sys.ssh = {
    enable = myUtils.mkEnabledOption "networking";
    port = lib.mkOption {
      type = lib.types.port;
      default = 2645;
    };
    fail2ban = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable Fail2Ban for ssh";
    };
  };
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      ports = [cfg.port];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [config.sys.users.default.name];
        X11Forwarding = false;
        AllowTcpForwarding = "no";
      };
    };
    services.fail2ban.enable = cfg.fail2ban;
  };
}
