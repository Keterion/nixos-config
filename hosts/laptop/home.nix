{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    ../../modules/system/runner.nix
    ../../modules/system/bar/waybar.nix
    ../../modules/system/shells/zsh.nix
  ];
  home.username = "etherion";
  home.homeDirectory = lib.mkForce "/home/etherion/";

  home.packages = with pkgs; [
    android-tools

    #unciv
    keepassxc
    #rustup
    #cargo
    #rust-analyzer
    spotdl
    yt-dlp
    git
    obsidian
    qimgv
    aseprite
    wluma
    strawberry-qt6
    krita
    qbittorrent
    exiftool
    mediainfo
    ffmpeg
    busybox
    bat
    #filter
    #fastfetch
    zip
    xz
    unzip
    ripgrep
    #network
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    #misc
    tree

    #nix
    nix-output-monitor #nom
    #productivity
    bottom
    iotop
    iftop
    gpodder
  ];
  #programs.steam.enable = true; doesn't work, put elsewhere

  shells.zsh = {
    enable = true;
    aliases = {
      ll = "eza -lao --time-style '+%Y%m%d %H:%M:%S' --icons=auto --color=always";
      rotate = "sudo nixos-rebuild switch --show-trace --print-build-logs --verbose --flake /etc/nixos\#laptop";
      nixconf = "sudo nvim /etc/nixos";
    };
    eza.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
  };

  system.runner.tofi.enable = true;


  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
