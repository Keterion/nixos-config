{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.brightnessctl;
in {
  options.apps.brightnessctl.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable brightnessctl";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
    ];
  };
}
