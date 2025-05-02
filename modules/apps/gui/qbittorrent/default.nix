{ lib, pkgs, config, ... }:
let
  cfg = config.apps.qbittorrent;
in {
  options.apps.qbittorrent.enable = lib.mkOption {
    default = config.apps.modules.gui.misc.enable;
    type = lib.types.bool;
    description = "Whether to enable qbittorrent.";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.qbittorrent
    ];
  };
}
