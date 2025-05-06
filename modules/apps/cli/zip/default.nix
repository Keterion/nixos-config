 { lib, pkgs, config, ... }:
let
  cfg = config.apps.zip;
in {
  options.apps.zip.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable zip.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zip
    ];
  };
}
