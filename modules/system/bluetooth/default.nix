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
      settings.General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
        AlwaysPairable = true; # always allow pairing even without agents
        FastConnectable = true;
        NameResolving = true; # get bt device name, takes time
      };
    };
    services.blueman.enable = true;
  };
}
