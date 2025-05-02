{ lib, pkgs, config, ... }:
let
  cfg = config.apps.obsidian;
in {
  options.apps.obsidian.enable = lib.mkOption {
    default = config.apps.modules.gui.misc.enable;
    type = lib.types.bool;
    description = "Whether to enable obsidian.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.obsidian
    ];
  };
}
