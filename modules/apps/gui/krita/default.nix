{ lib, pkgs, config, ... }:
let
  cfg = config.apps.krita;
in {
  options.apps.krita.enable = lib.mkOption {
    default = config.apps.modules.gui.art.dd.enable;
    type = lib.types.bool;
    description = "Whether to enable krita.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.krita
    ];
  };
}
