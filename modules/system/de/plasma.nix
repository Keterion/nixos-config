{ config, lib, ... }:
let
  cfg = config.system.de.plasma;
in {
  options.system.de.plasma.enable = lib.mkEnableOption "plasma de";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
