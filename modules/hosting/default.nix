{ config, lib, ... }:
let
  cfg = config.hosting;
in {
  imports = [
    ./bazarr
    ./calibre
    ./jellyfin
    ./prowlarr
  ];

  options.hosting = {
    defaultGroup = lib.mkOption {
      type = lib.types.str;
      default = "server";
      description = "Default group to use for all services";
    };
    openFirewall = lib.mkEnableOption "open Firewall for all services";
    ip = lib.mkOption {
      type = lib.types.str;
      default = "::1";
      description = "IP to use";
    };
  };
}
