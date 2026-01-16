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
      sops.secrets = lib.mkIf cfg.wireless.enable {
        "eduroam/identity" = {};
        "eduroam/password" = {};
        "eduroam/domain" = {};
      };
      sops.templates."wireless_secrets" = lib.mkIf cfg.wireless.enable {
        content = ''
          eduroam_identity=${config.sops.placeholder."eduroam/identity"}
          eduroam_privkey_passwd=${config.sops.placeholder."eduroam/password"}
          eduroam_domain=${config.sops.placeholder."eduroam/domain"}
        '';
      };

      networking.networkmanager.enable = true;
      networking.wireless = lib.mkIf cfg.wireless.enable {
        enable = cfg.wireless.enable;
        userControlled.enable = true;
        allowAuxillaryImperativeNetworks = true;
        networks = {
          #eduroam = {
          #  extraConfig = ''
          #    ssid="eduroam"
          #    key_mgmt=TLS
          #  '';
          #  auth = ''
          #    identity=ext:eduroam_identity
          #    private_key_passwd=ext:eduroam_privkey_passwd
          #    domain=ext:eduroam_domain
          #  '';
          #};
        };
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
