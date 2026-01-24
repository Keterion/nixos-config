{
  lib,
  config,
  ...
}: let
  cfg = config.sys.dm.sddm;
in {
  options.sys.dm.sddm = {
    enable = lib.mkEnableOption "sddm";
    styleProfile = lib.mkOption {
      type = lib.types.enum ["default"];
      default = "default";
      description = "Style profile to use";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      settings = import ./sddm/${cfg.styleProfile}.nix;
    };
  };
}
