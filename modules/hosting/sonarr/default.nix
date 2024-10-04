{ lib, pkgs, config, ... }:
let
  cfg = config.modules.services.sonarr;
in {
  options.modules.services.sonarr = {
    enable = lib.mkEnableOption "the Sonarr series manager";
    dataDir = lib.mkOption {
      description = "The directory where Sonarr stores its data files";
      default "/var/lib/sonarr/.config/NzbDrone";
      type = lib.types.string;
    };
  };
  config = lib.mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      dataDir = cfg.dataDir;
      group = "server";
      openFirewall = config.modules.hosting.openFirewall;
      user = "sonarr";
    };
  };
}
