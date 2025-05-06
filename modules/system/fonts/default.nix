{ config, lib, pkgs, ... }:
let
  cfg = config.system.fonts;
in {
  options.system.fonts = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ pkgs.nerd-fonts.hack ];
    description = "Fonts to install globally";
  };

  config = {
    fonts.packages = cfg;
  };
}
