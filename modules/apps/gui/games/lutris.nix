{ lib, pkgs, config, ... }:
let 
  cfg = config.apps.games.lutris;
in {
  options.apps.games.lutris.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable lutris";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.lutris ];
  };
}
