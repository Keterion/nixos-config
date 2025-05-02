{ lib, pkgs, config, ... }:
let
  cfg = config.apps.signal;
in {
  options.apps.signal.enable = lib.mkOption {
    default = config.apps.modules.gui.social.enable;
    type = lib.types.bool;
    description = "Whether to enable signal.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.signal
    ];
  };
}
