{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.discord;
in {
  options.apps.discord = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.social.enable;
      type = lib.types.bool;
      description = "Whether to enable discord";
    };
    vencord.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to patch discord with vencord";
    };
    moonlight.enable = lib.mkEnableOption "patch discord with moonlight";
    openASAR.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to replace the discord .asar file with openASAR";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs.stable; [
      (discord.override {
        withVencord = cfg.vencord.enable;
        withMoonlight = cfg.moonlight.enable;
        withOpenASAR = cfg.openASAR.enable;
      })
    ];
  };
}
