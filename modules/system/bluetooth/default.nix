{
  lib,
  config,
  ...
}: let
  cfg = config.sys.bluetooth;
in {
  options.sys.bluetooth.enable = lib.mkEnableOption "bluetooth support";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
    services.blueman.enable = true;
  };
}
