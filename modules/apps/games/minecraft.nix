{ pkgs, config, lib, ...}: {
  options.modules.apps.games.minecraft = {
    enable = lib.mkEnableOption "minecraft";
  };

  config = lib.mkIf config.modules.apps.games.minecraft.enable {
    home-manager.users."etherion" = {
      home.packages = [
        pkgs.prismlauncher
      ];
    };
  };
}
