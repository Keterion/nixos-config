{ pkgs, config, lib, ... }:
let
  cfg = config.apps.games.minecraft;
in {
  options.apps.games.minecraft.enable = lib.mkEnableOption "minecraft via prismlauncher";

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.packages = with pkgs; [
      prismlauncher
      jdk17
      jdk8
    ];
  };
}
