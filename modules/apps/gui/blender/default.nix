{ lib, pkgs, config, ... }:
let
  cfg = config.apps.blender;
in {
  options.apps.blender.enable = lib.mkEnableOption "blender";

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = with pkgs; [
      blender
    ];
  };
}
