{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.mullvad-vpn;
in {
  options.apps.mullvad-vpn = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      enableExcludeWrapper = true;
    };
  };
}
