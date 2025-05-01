{ lib, pkgs, config, ... }:
let cfg = config.modules.services.qbittorrent;
in {
  options.modules.services.qbittorrent = {
    enable = lib.mkEnableOption "qbittorrent";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.hosting.openFirewall;
      description = "the firewall rule for qbittorrent";
    };
    port = lib.mkOption {
      type = lib.types.ints.u32;
      default = 8080;
      description = "Port to use for the radicale server";
    };

  };

  config = lib.mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      openFirewall = lib.mkDefault cfg.openFirewall;
      user = "qbittorrent";

      port = cfg.port;
    };
  };
}
