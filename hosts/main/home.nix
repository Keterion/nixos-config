{ config, lib, inputs, pkgs, vars, ... }: {
  imports = [
    ../../modules/system/runner.nix
    ../../modules/system/bar/waybar.nix
    ../../modules/system/shells/zsh.nix
    ../../modules/apps/hm.nix
    inputs.arkenfox.hmModules.arkenfox
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.username = "etherion";
  home.homeDirectory = lib.mkForce "/home/etherion/";
  home.packages = with pkgs; [
    #android-tools
    blender
    webcord-vencord
    keepassxc
    spotdl
    yt-dlp
    git
    obsidian
    qimgv
    #aseprite
    strawberry-qt6
    krita
    qbittorrent
    exiftool
    mediainfo
    ffmpeg
    #unstable.busybox
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

    encfs

    obs-studio #TODO

    #misc
    tree

    #nix
    nix-output-monitor #nom
    #productivity
    bottom
    iotop
    iftop
    gpodder
    signal-desktop
    zathura
  ];
  
  modules.apps.firefox = {
    enable = true;
    arkenfox = true;
    devEdition = true;
  };
  modules.apps = {
    spotify = {
      enable = false;
    };
    spicetify = {
      enable = true;
      cli = false;
    };
    cava.enable = true;

    neovim = {
      enable = false;
    };
    nixvim.enable = true;
  };

  shells.zsh = {
    enable = true;
    aliases = {
      ll = "eza -lao --time-style '+%Y%m%d %H:%M:%S' --icons=auto --color=always";
      rotate = "sudo nixos-rebuild switch --show-trace --print-build-logs --verbose --flake /etc/nixos\#main";
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
