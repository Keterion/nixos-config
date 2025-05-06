 { lib, pkgs, config, ... }:
let
  cfg = config.apps.bottom;
in {
  options.apps.bottom.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable bottom as a top-like utility.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottom
    ];
  };
}
