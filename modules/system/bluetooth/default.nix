{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.sys.bluetooth;
in {
  options.sys.bluetooth.enable = lib.mkEnableOption "bluetooth support";

  config = lib.mkIf cfg.enable {
    #boot.kernelPatches = builtins.trace "Applying kernel patch to fix bluetooth" [
    #  {
    #    name = "Bluetooth: btmtk: accept too short WMT FUNC_CTRL events";
    #    patch = pkgs.fetchurl {
    #      url = "https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/patch/?id=162b1adeb057d28ad84fd8a03f3c50cf08db5c62";
    #      hash = "sha256-ij0hQmC0U++AdXWQy6nycnDe6z4yaMoQIrSiLal5DHc=";
    #    };
    #  }
    #];
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
