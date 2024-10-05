{ lib, pkgs, config, ... }:
let
  cfg = config.modules.services.prowlarr;
in {
  options.modules.services.prowlarr = {
    enable = lib.mkEnableOption "the prowlarr source organizer";
  };
  config = lib.mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = lib.mkDefault config.modules.hosting.openFirewall;
    };
  };
}
