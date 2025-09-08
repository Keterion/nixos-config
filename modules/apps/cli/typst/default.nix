{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.typst;
in {
  options.apps.typst = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      typst
    ];
  };
}
