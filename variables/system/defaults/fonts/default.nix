{ config, lib, pkgs, ... }:
let
  cfg = config.system.defaults.font;
in {
  options.system.defaults.font = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nerd-fonts.hack;
      description = "Default font";
      example = pkgs.nerd-fonts.jetbrains-mono;
  };

  config = {
    system.fonts = cfg;
  };
}
