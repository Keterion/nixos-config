{ osConfig, config, lib, inputs, pkgs, vars, ... }: {
  imports = [
    ../../modules/system/runner
    ../../modules/system/bar/waybar.nix
    ../../modules/system/shell
    ../../modules/apps/hm.nix
    inputs.arkenfox.hmModules.arkenfox
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.username = "${osConfig.vars.globals.defaultUser.name}";
  home.packages = with pkgs; [
    #android-tools
    speedcrunch
    gnome-calendar
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
    #nix-output-monitor #nom
    #productivity
    bottom
    iotop
    iftop
    gpodder
    signal-desktop
    zathura
  ];
  
  accounts = {
    calendar = {
      basePath = "~/Documents/.calendar";
      accounts = {
	"${osConfig.vars.globals.defaultUser.name}" = {
	  primary = true;
	  remote = {
	    type = "caldav";
	    url = "http://localhost:5232/etherion/1dc56c74-3149-0561-3e47-d346a9c5a331/";
	    userName = "etherion";
	  };
	};
      };
    };
    
  };
  modules.apps.firefox = {
    enable = true;
    arkenfox = true;
    package = pkgs.firefox;
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

  system.shell = {
    zsh = {
      enable = true;
      aliases = {
	ll = "eza -lao --time-style '+%Y%m%d %H:%M:%S' --icons=auto --color=always";
	rotate = "sudo nixos-rebuild switch --show-trace --print-build-logs --verbose --flake /etc/nixos\#main";
	nixconf = "sudo nvim /etc/nixos";
      };
    };
    nushell.enable = true;
    eza.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
    prompt.starship.enable = true;
  };

  system.runner.tofi.enable = true;


  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
