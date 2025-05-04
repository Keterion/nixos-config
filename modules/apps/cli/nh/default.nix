{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.nh;
in {
  options.apps.nh.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nh
    ];
  };
}
