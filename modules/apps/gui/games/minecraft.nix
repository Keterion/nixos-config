{ pkgs, config, lib, ... }:
let
  cfg = config.apps.games.minecraft;
in {
  options.apps.games.minecraft.enable = lib.mkOption {
    default = config.apps.modules.gui.all.enable;
    type = lib.types.bool;
    description = "Whether to enable Minecraft via prismlauncher.";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = with pkgs; [
      prismlauncher
      jdk17
      jdk8
    ];
  };
}
