{ config, lib, ... }:
let
  cfg = config.system.runner.tofi;
in {
  options.system.runner.tofi = {
    enable = lib.mkEnableOption "tofi";
    styleProfile = lib.mkOption {
      type = lib.types.enum["etherion"];
      default = "etherion";
      description = "The style profile to use for tofi theming";
    };
  };

  config = lib.mkIf cfg.enable {
    system.runner.command = "tofi-run";
    home-manager.users.${config.system.users.default.name} = {
      programs.tofi.enable = true;
      imports = [
	./tofi/${cfg.styleProfile}.nix
      ];
    };	
  };
}
