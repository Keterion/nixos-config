{
  pkgs,
  config,
  ...
}: let
  main_user = "Hypnos";
in {
  imports = [./hardware-configuration.nix];

  nix.package = pkgs.lixPackageSets.stable.lix;

  networking.hostName = main_user;
  networking.hosts = builtins.trace "wowie" {
    "${config.hosting.ip}" = ["host"];
  };
  system.users.default = {
    name = main_user;
    git = {
      name = "Keterion";
      email = "100532848+Keterion@users.noreply.github.com";
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024; # 12GB + 4GB RAM = 16
    }
  ];

  #nix.package = pkgs.lixPackageSets.stable.lix;

  system = {
    configDir = /home/${main_user}/nixos;
    colorscheme = "tokyonight-moon";
    #sops.age.keyFile = "/home/Hypnos/.config/sops/age/keys.txt";

    security.firejail.enable = true;

    audio.pipewire = {
      enable = true;
      rtkit.enable = true;
      loopback.enable = true;
      compatibility.pulse.enable = true;
      compatibility.jack.enable = true;
    };
    graphics.intel = {
      enable = false;
      old.enable = false;
    };
    firewall.enable = true;
    network = {
      enable = true;
      wireless.enable = false;
    };
    ssh = {
      enable = true;
      fail2ban = false;
    };
    bluetooth.enable = false;
    fonts = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.heavy-data
      nerd-fonts.jetbrains-mono
    ];

    keyboard = {
      layout = "us";
      variant = "dvorak";
    };
    terminal.kitty = {
      enable = true;
      default = true;
    };

    bar.waybar = {
      enable = true;
      styleProfile = "haides002";
    };
    de = {
      hyprland = {
        enable = true;
        autologin = false;
        utils.enable = true;
        styleProfile = "etherion";
        hypridle.enable = true;
        wlsunset.enable = true;
        wallpaper = {
          enable = true;
          wallhaven.enable = false;
        };
      };
      plasma.enable = true;
    };

    screenlocker.swaylock.enable = true;

    dm.sddm.enable = true;

    runner = {
      tofi = {
        enable = true;
        styleProfile = "etherion";
      };
    };

    shell = {
      prompt.starship.enable = true;
      zsh = {
        enable = true;
        global = {
          autosuggestions.enable = true;
          aliases = {
            ll = "ls -la";
            l = "ls -la";
          };
        };
        user = {
          default = true;
          autocd = false;
          autosuggestion = {
            enable = true;
            highlight = "underline";
          };
          enableCompletion = true;
          history = {
            ignoreDups = true;
            ignoreSpace = true;
            substringSearch = {
              enable = true;
            };
          };
        };
      };
    };

    printing = {
      enable = true;
      autodiscovery.enable = true;
    };
  };

  scripts.api.wallhaven.enable = true;
  apps = {
    modules.all.enable = false; # Enables all apps under modules/apps
    modules.cli.all.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    mullvad-vpn.enable = false;
    keepassxc.enable = true;
    firefox.enable = true;
    bc.enable = true;
    zathura.enable = true;
    games = {
      steam = {
        enable = true;
        compat = true;
        backup = true;
        millennium.enable = false;
      };
      minecraft.enable = true;
    };

    discord = {
      enable = true;
      vencord.enable = true;
    };
    eza = {
      shellIntegration = true;
      overrides.shellIntegration.nushell.enable = false;
    };
    fzf.shellIntegration = true;
    zoxide.shellIntegration = true;
  };
  hosting = {
    openFirewall = true;
    ip = "192.168.178.191";
    defaultGroup = "server";

    #copyparty.enable = true;
    syncthing = {
      enable = false;
      config.directories = [
        {
          id = "rcnav-y6mqj";
          label = "Obsidian";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Documents/Obsidian";
          type = "sendreceive";
        }
        {
          id = "t7ez7-ezwxh";
          label = "Passwords";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Documents/Passwords";
        }
        {
          id = "m3xdc-10b3a";
          label = "Sync";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Sync";
        }
        {
          id = "oci0b-orq3j";
          label = "University";
          devices = ["Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Documents/School/University";
        }
      ];
    };
    firefox-syncserver = {
      enable = false;
      setFirefoxServer = true;
    };
    readeck.enable = false;
    mpd = {
      enable = false;
      directories = {
        music = "/home/${main_user}/Music/songs/";
        playlist = "/home/${main_user}/Music/songs/playlists/";
      };
      startWhenNeeded = false;
      user = "${main_user}";
    };
    navidrome = {
      enable = false;
      directories = {
        music = "/home/${main_user}/Music/songs/";
        playlist = "/home/${main_user}/Music/songs/playlists/";
      };
    };
  };
}
