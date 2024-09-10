{ pkgs, config, lib, ...}:
{
  options.modules.system.wm.plasma.enable = lib.mkEnableOption "plasma 6";

  config = lib.mkIf config.modules.system.wm.plasma.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
