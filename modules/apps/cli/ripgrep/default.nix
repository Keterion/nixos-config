 { lib, pkgs, config, ... }:
let
  cfg = config.apps.ripgrep;
in {
  options.apps.ripgrep.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable ripgrep, a faster grep.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ripgrep
    ];
  };
}
