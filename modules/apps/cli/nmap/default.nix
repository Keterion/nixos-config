 { lib, pkgs, config, ... }:
let
  cfg = config.apps.nmap;
in {
  options.apps.nmap.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable nmap.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nmap
    ];
  };
}
