{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.betaflight;
in {
  options.apps.betaflight.enable = lib.mkOption {
    default = config.apps.modules.gui.utils.enable;
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      betaflight-configurator
    ];
    system.users.default.extraGroups = ["dialout" "plugdev"];
    services.udev.packages = [
      (pkgs.writeTextDir "lib/udev/rules.d/70-stm32-dfu.rules" ''
        # DFU (Internal bootloader for STM32 and AT32 MCUs)
        SUBSYSTEM=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", TAG+="uaccess"
      '')
    ];
  };
}
