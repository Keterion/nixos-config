{ lib, pkgs, config, ... }:
let
  cfg = config.modules.services.bazarr;
in {
  options.modules.services.bazarr = {
    enable = lib.mkEnableOption "the bazarr subtitle managing service for Sonarr and Radarr";
  };
  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      listenPort = 6767;
      openFirewall = lib.mkDefault config.modules.hosting.openFirewall;
      user = "bazarr";
    };
  };
}
