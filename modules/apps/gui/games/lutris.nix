{ lib, pkgs, config, ... }:
let 
  cfg = config.apps.games.lutris;
in {
  options.apps.games.lutris.enable = lib.mkEnableOption "the lutris game launcher & manager";

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [ pkgs.lutris ];
  };
}
