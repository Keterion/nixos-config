{ lib, pkgs, config, ... }:
let
  cfg = config.modules.services.radarr;
in {
  options.modules.services.radarr = {
    enable = lib.mkEnableOption "the radarr movie manager";
  };
  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      group = "server";
      openFirewall = config.modules.hosting.openFirewall;
      user = "radarr";
  };
}
