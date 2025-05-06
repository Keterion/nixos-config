{ lib, config, ... }:
let
  cfg = config.system.dm.ly;
in {
  options.system.dm.ly = {
    enable = lib.mkEnableOption "ly";
    styleProfile = lib.mkOption {
      type = lib.types.enum["default"];
      default = "default";
      description = "Style profile to use";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
      settings = import ./ly/${cfg.styleProfile}.nix;
    };
  };
}
