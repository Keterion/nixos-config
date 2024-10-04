{ lib, config, pkgs, ...}:
let
  cfg = config.modules.privacy;
in
{
  options.modules.privacy.vpn = {
    enable = lib.mkEnableOption "a vpn service";
  };

  config = lib.mkIf cfg.vpn.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
      enableExcludeWrapper = true;
    };
  };
}
