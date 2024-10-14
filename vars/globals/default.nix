{ lib, pkgs, config, ... }:
let
  cfg = vars.globals;
in {
  imports = [];
  options.vars.globals = {
    defaultUser = lib.mkOption {
      type = lib.types.str;
      description = "The default user, all other users need to be configured per system";
      example = "etherion";
    };
    keyboard = {
      layout = lib.mkOption {
        type = lib.types.str;
	description = "The layout(s) to use, separated by commas";
	default = "us";
	example = "us,ru";
      };
      variant = lib.mkOption {
        type = lib.types.str;
	description = "The variant(s) to use for the layouts";
	default = "";
	example = "dvorak";
      };
    };
  };
}
