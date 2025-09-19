{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.nmtui;
in {
  options.apps.nmtui = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
      description = "Whether to enable nmtui.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.networkmanager];
  };
}
