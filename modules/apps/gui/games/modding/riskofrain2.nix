{ pkgs, config, lib, ... }:
let
  cfg = config.apps.games.mods.ror2;
in {
  options.apps.games.mods.ror2 = {
    enable = lib.mkEnableOption "tools to mod risk of rain 2";
    dirs = {
      install = lib.mkOption {
	type = lib.types.path;
	description = "Risk of Rain 2 install path";
	example = "/mnt/Games/Steam/steamapps/common/Risk of Rain 2";
      };
      compat = lib.mkOption {
	type = lib.types.path;
	description = "Risk of Rain 2 compatdata path";
	example = /mnt/Games/Steam/steamapps/compatdata/632360;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.r2mod_cli ];
    environment.variables = {
      R2MOD_INSTALL_DIR = "${cfg.dirs.install}";
      R2MOD_COMPAT_DIR = "${cfg.dirs.compat}";
    };
  };
}
