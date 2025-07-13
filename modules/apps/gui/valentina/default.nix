{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.valentina;
in {
  options.apps.valentina = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.art.dd.enable;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      valentina
    ];
  };
}
