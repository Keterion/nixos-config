{ config, lib, ... }:
let
  cfg = config.apps.modules.gui;
in {
  imports = [
    ./blender
    ./firefox
    ./freecad
    ./games
    ./jellyfin-media-player
    ./keepassxc
    ./discord
    ./libreoffice
    ./thunderbird
    ./mpv
    ./speedcrunch
  ];

  options.apps.modules.gui = {
    all.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.apps.modules.all.enable; # All gui and cli programs enabled
      description = "Whether to enable all gui programs";
    };
    art = {
      enable = lib.mkOption {
	default = cfg.all.enable;
	type = lib.types.bool;
	description = "Whether to enable all art programs";
      };
    };
    social.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all social programs";
    };
  };

  config.apps = {
    blender.enable = lib.mkDefault cfg.art.enable;

    discord.enable = lib.mkDefault cfg.social.enable;
    thunderbird.enable = lib.mkDefault cfg.social.enable;
  };
}
