{ pkgs, config, lib, ...}:
{
  options.system.wm.plasma.enable = lib.mkEnableOption "plasma 6";

  config = lib.mkIf config.system.wm.plasma.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
