{
  lib,
  myUtils,
  config,
  ...
}: let
  cfg = config.system.networking;
in {
  options.system.networking = {
    enable = myUtils.mkEnabledOption "networking";
    wireless.enable = lib.mkEnableOption "wifi";
    ssh = {
      enable = lib.mkEnableOption "ssh";
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
  };
  config =
    lib.mkIf cfg.enable {
      networking.networkmanager.enable = !cfg.wireless.enable;
      networking.wireless = lib.mkIf cfg.wireless.enable {
        enable = cfg.wireless.enable;
        userControlled.enable = true;
        extraConfig = '''';
      };
    }
    // lib.mkIf cfg.ssh.enable {
      services.openssh = {
        enable = true;
        #ports = [cfg.ssh.port];
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [config.system.users.default.name];
          X11Forwarding = "no";
          AllowTcpForwarding = "no";
        };
      };
      services.fail2ban.enable = cfg.ssh.fail2ban;
    };
}
