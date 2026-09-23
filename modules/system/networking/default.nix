{
  lib,
  config,
  myUtils,
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
    nftables.enable = myUtils.mkEnabledOption "nftables as replacement for iptables";
    wireless = {
      enable = lib.mkEnableOption "wifi";
      imperative = myUtils.mkEnabledOption "imperative wifi config via wpa_cli or something";
    };
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

    networking.nftables.enable = cfg.nftables.enable;

    networking.networkmanager.enable = cfg.wireless.enable;

    #networking.wireless = lib.mkIf cfg.wireless.enable {
    #  enable = cfg.wireless.enable;
    #  userControlled = cfg.wireless.imperative;
    #  allowAuxiliaryImperativeNetworks = cfg.wireless.imperative;
    #  #networks = {
    #  #eduroam = {
    #  #  extraConfig = ''
    #  #    ssid="eduroam"
    #  #    key_mgmt=TLS
    #  #  '';
    #  #  auth = ''
    #  #    identity=ext:eduroam_identity
    #  #    private_key_passwd=ext:eduroam_privkey_passwd
    #  #    domain=ext:eduroam_domain
    #  #  '';
    #  #};
    #  #};
    #};
    sys.users.default.extraGroups = lib.optionals cfg.wireless.enable [
      #"wpa_supplicant"
      "networkmanager"
    ];

    networking.resolvconf.enable = false;
    services.resolved.enable = true;
    networking.hosts = {
      "192.168.0.178" = ["server"];
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
