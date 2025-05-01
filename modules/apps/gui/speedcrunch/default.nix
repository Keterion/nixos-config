{ lib, pkgs, config, ... }:
let
  cfg = config.apps.speedcrunch;
in {
  options.apps.speedcrunch.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable speedcrunch.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      speedcrunch
    ];
  };
}
