{
  lib,
  config,
  ...
}: let
  cfg = config.sys.network;
in {
  options.sys.network = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable network capabilities";
    };
    wireless.enable = lib.mkEnableOption "wifi";
  };
  config = lib.mkIf cfg.enable {
    #sops.secrets = lib.mkIf cfg.wireless.enable {
    #  "eduroam/identity" = {};
    #  "eduroam/password" = {};
    #  "eduroam/domain" = {};
    #};
    #sops.templates."wireless_secrets" = lib.mkIf cfg.wireless.enable {
    #  content = ''
    #    eduroam_identity=${config.sops.placeholder."eduroam/identity"}
    #    eduroam_privkey_passwd=${config.sops.placeholder."eduroam/password"}
    #    eduroam_domain=${config.sops.placeholder."eduroam/domain"}
    #  '';
    #};

    networking.wireless = lib.mkIf cfg.wireless.enable {
      enable = cfg.wireless.enable;
      userControlled = true;
      allowAuxiliaryImperativeNetworks = true;
      #networks = {
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
      #};
    };
    networking.hosts = {
      "127.0.0.2" = ["other-localhost"];
      "192.168.0.123" = ["server"];
      #networking.wireless = lib.mkIf cfg.wireless.enable {
      #  enable = cfg.wireless.enable;
      #  userControlled.enable = true;
      #  allowAuxillaryImperativeNetworks = true;
      #  networks = {
      #    eduroam = {
      #      extraConfig = ''
      #        ssid="eduroam"
      #        key_mgmt=TLS
      #      '';
      #      auth = ''
      #        identity=ext:eduroam_identity
      #        private_key_passwd=ext:eduroam_privkey_passwd
      #        domain=ext:eduroam_domain
      #      '';
      #    };
      #  };
      #};
    };
  };
}
