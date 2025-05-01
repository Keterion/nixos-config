{ lib, pkgs, config, ... }:
let
  cfg = config.apps.keepassxc;
in {
  options.apps.keepassxc.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable keepassxc for kdbx databases.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];
  };
}
