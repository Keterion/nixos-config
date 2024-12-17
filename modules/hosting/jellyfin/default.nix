{ lib, pkgs, config, ...}:
let
  cfg = config.modules.services.jellyfin;
in {
  options.modules.services.jellyfin = {
    enable = lib.mkEnableOption "The jellyfin server";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.hosting.openFirewall;
      description = "the firewall rule for jellyfin server";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      dataDir = "/var/lib/jellyfin";
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      openFirewall = cfg.openFirewall;
      user = "jellyfin";
    };
  };
}
