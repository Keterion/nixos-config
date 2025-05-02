{ config, lib, pkgs, ... }:
let
  cfg = config.apps.modules.cli;
in {
  imports = [
    ./bat
    ./bottom
    ./cava
    ./encfs
    ./exiftool
    ./eza
    ./ffmpeg
    ./fzf
    ./git
    ./mediainfo
    ./neovim
    ./nmap
    ./ripgrep
    ./spotdl
    ./tdf
    ./testssl
    ./yt-dlp
    ./zip
    ./zoxide
  ];

  options.apps.modules.cli = {
    all.enable = lib.mkOption {
      default = config.apps.modules.all.enable; # All modules, gui and cli
      type = lib.types.bool;
      description = "Whether to enable all cli programs";
    };
    dev.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable dev programs";
    };
    dl.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable download programs";
    };
    media.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable media programs";
    };
    misc.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable miscellaneous programs";
    };
    utils.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable utility programs";
    };
  };
}
