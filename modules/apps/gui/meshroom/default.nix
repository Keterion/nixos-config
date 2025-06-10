{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.meshroom;
in {
  imports = [
    ./../../../packages/meshroom
  ];
  options.apps.meshroom.enable = lib.mkOption {
    default = config.apps.modules.gui.art.ddd.enable;
    type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.meshroom
    ];
  };
}
