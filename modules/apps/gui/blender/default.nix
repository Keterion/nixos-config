{ lib, pkgs, config, ... }:
let
  cfg = config.apps.blender;
in {
  options.apps.blender.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable blender";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = with pkgs; [
      blender
    ];
  };
}
