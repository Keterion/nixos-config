{ lib, pkgs, config, ... }:
let
  cfg = config.apps.bat;
in {
  options.apps.bat.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable bat instead of cat.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
    ];
  };
}
