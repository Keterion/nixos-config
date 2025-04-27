{ config, lib, pkgs, ... }:
let
  cfg = config.apps.discord;
in {
  options.apps.discord = {
    enable = lib.mkEnableOption "discord";
    vencord.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to patch discord with vencord";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (discord-canary.override {
	withVencord = cfg.vencord.enable;
      })
    ];
  };
}
