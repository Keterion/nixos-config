{
  config,
  lib,
  ...
}: let
  cfg = config.apps.modules.cli;
in {
  imports = [
    ./bat
    ./bc
    ./beets
    ./bottom
    ./brightnessctl
    ./carapace
    ./cava
    ./encfs
    ./exiftool
    ./eza
    ./ffmpeg
    ./fzf
    ./git
    ./lazygit
    ./mediainfo
    ./neovim
    ./nh
    ./nix-alien
    ./nmap
    ./nmtui
    ./pueue
    ./ripgrep
    ./rmpc
    ./rsync
    ./spotdl
    ./tdf
    ./testssl
    ./tmux
    ./typst
    ./yazi
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

  config = {
    apps = {
      bat.enable = lib.mkDefault cfg.utils.enable;
      bc.enable = lib.mkDefault cfg.utils.enable;
      bottom.enable = lib.mkDefault cfg.utils.enable;
      brightnessctl.enable = lib.mkDefault cfg.utils.enable;
      nix-alien.enable = lib.mkDefault cfg.utils.enable;
      nmap.enable = lib.mkDefault cfg.utils.enable;
      nmtui.enable = lib.mkDefault cfg.utils.enable;
      ripgrep.enable = lib.mkDefault cfg.utils.enable;
      rsync.enable = lib.mkDefault cfg.utils.enable;
      testssl.enable = lib.mkDefault cfg.utils.enable;
      tmux.enable = lib.mkDefault cfg.utils.enable;
      typst.enable = lib.mkDefault cfg.utils.enable;

      encfs.enable = lib.mkDefault cfg.misc.enable;

      exiftool.enable = lib.mkDefault cfg.media.enable;
      ffmpeg.enable = lib.mkDefault cfg.media.enable;
      tdf.enable = lib.mkDefault cfg.media.enable;
      mediainfo.enable = lib.mkDefault cfg.media.enable;

      yt-dlp.enable = lib.mkDefault cfg.dl.enable;
      spotdl.enable = lib.mkDefault cfg.dl.enable;
    };
  };
}
