{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.bc;
in {
  options.apps.bc = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.apps.cli.modules.utils.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bc
    ];
  };
}
