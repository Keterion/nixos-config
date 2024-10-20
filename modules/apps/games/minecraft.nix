{ pkgs, config, lib, ...}: {
  options.modules.apps.games.minecraft = {
    enable = lib.mkEnableOption "minecraft";
  };

  config = lib.mkIf config.modules.apps.games.minecraft.enable {
    home-manager.users.${config.vars.globals.defaultUser.name} = {
      home.packages = [
        pkgs.prismlauncher
	pkgs.jdk17
      ];
    };
  };
}
