{ lib, pkgs, config, ... }:
let
  cfg = config.apps.strawberry;
in {
  options.apps.strawberry.enable = lib.mkOption {
    default = config.apps.modules.gui.media.enable;
    type = lib.types.bool;
    description = "Whether to enable strawberry.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.strawberry
    ];
  };
}
