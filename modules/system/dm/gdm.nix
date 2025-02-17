{ lib, config, ... }:
let
  cfg = config.system.dm.gdm;
in {
  options.system.dm.gdm = {
    enable = lib.mkEnableOption "gdm";
    banner = lib.mkOption {
      type = lib.types.str;
      default = config.system.dm.greet;
      example = ''
	foo
	bar
	baz
      '';
    };
    styleProfile = lib.mkOption {
      type = lib.types.enum["default" "etherion"];
      default = "default";
      example = "etherion";
      description = "Style profile to use";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
      banner = cfg.banner;
      settings = import ./gdm/${cfg.styleProfile}.nix;
    };
  };
}
