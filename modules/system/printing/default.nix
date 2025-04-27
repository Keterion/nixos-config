{ lib, config, ... }:
let
  cfg = config.system.printing;
in {
  options.system.priting = {
    enable = lib.mkEnableOption "wireless printing support";
    autodiscovery.enable = lib.mkEnableOption "autodiscovery with avahi";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = lib.mkIf cfg.autodiscovery.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
