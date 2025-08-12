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
      betaflight
    ];
  };
}
