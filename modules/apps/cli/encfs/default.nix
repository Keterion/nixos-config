 { lib, pkgs, config, ... }:
let
  cfg = config.apps.encfs;
in {
  options.apps.encfs.enable = lib.mkOption {
    default = config.apps.modules.cli.misc.enable;
    type = lib.types.bool;
    description = "Whether to enable encfs for encrypted folders.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      encfs
    ];
  };
}
