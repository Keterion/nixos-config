{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.fonts;
in {
  options.sys.fonts = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [pkgs.nerd-fonts.hack];
    description = "Fonts to install globally";
  };

  config = {
    fonts.packages = cfg;
  };
}
