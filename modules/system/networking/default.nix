{
  lib,
  myUtils,
  config,
  ...
}: let
  cfg = config.system.networking;
in {
  options.system.networking = {
    enable = myUtils.mkEnabledOption "networking";
    wireless.enable = lib.mkEnableOption "wifi";
  };
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = !cfg.wireless.enable;
    networking.wireless = lib.mkIf cfg.wireless.enable {
      enable = cfg.wireless.enable;
      userControlled.enable = true;
      extraConfig = '''';
    };
  };
}
