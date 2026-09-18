{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.de.plasma-bigscreen;
in {
  options.sys.de.plasma-bigscreen.enable = lib.mkEnableOption "plasma de for televisions";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.desktopManager.sessionPackages = [pkgs.kdePackages.plasma-bigscreen];
  };
}
