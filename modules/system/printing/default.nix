{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.system.printing;
in {
  options.system.printing = {
    enable = lib.mkEnableOption "wireless printing support";
    autodiscovery.enable = lib.mkEnableOption "autodiscovery with avahi";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = lib.mkIf cfg.autodiscovery.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };
    services.printing.drivers = [pkgs.hplip];
  };
}
