{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.cartridges;
in {
  options.apps.cartridges = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.utils.enable;
      type = lib.types.bool;
      description = "Whether to enable cartridges, a game-launcher interface";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cartridges
    ];
  };
}
