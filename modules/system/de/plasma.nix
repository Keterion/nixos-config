{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.de.plasma;
in {
  options.sys.de.plasma.enable = lib.mkEnableOption "plasma de";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = [
      #pkgs.kdePackages.xwaylandvideobridge
    ];
  };
}
