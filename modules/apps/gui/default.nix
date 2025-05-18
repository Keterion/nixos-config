{
  config,
  lib,
  ...
}: let
  cfg = config.apps.modules.gui;
in {
  imports = [
    ./aseprite
    ./blender
    ./cartridges
    ./discord
    ./firefox
    ./freecad
    ./games
    ./gimp
    ./jellyfin-media-player
    ./keepassxc
    ./krita
    ./libreoffice
    ./mpv
    ./mullvad
    ./obs
    ./obsidian
    ./qbittorrent
    ./qimgv
    ./signal
    ./speedcrunch
    ./strawberry
    ./thunderbird
    ./zathura
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
      dd.enable = lib.mkOption {
        default = cfg.art.enable;
        type = lib.types.bool;
        description = "Whether to enable all 2d art programs";
      };
      ddd.enable = lib.mkOption {
        default = cfg.art.enable;
        type = lib.types.bool;
        description = "Whether to enable all 3d art programs";
      };
    };
    social.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all social programs";
    };
    media.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all media programs";
    };
    utils.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all utility programs";
    };
    misc.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all miscellaneous programs";
    };
    games.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable all gaming platforms";
    };
  };
}
