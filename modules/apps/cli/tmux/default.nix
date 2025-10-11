{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.tmux;
in {
  options.apps.tmux.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.apps.modules.cli.utils.enable;
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
