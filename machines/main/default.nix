{
  pkgs,
  config,
  ...
}: let
  main_user = "etherion";
in {
  imports = [./hardware-configuration.nix];
  networking.hostName = "main";
  sops.secrets = {
    "private_keys/etherion" = {
      path = "/home/etherion/.ssh/id_ed25519";
      owner = "etherion";
      mode = "0600";
    };
  };
  sys.users.default = {
    name = main_user;
    git = {
      name = "Keterion";
      email = "100532848+Keterion@users.noreply.github.com";
    };
    extraGroups = ["${config.hosting.defaultGroup}" "audio"];
  };
  sys = {
    configDir = /home/${main_user}/etc/nixos;
    colorscheme = "tokyonight-moon";
    security = {
      secureboot = {
        setup.utils = true;
        setup.done = true;
        enable = true;
      };
      firejail = {
        enable = true;
        defaultWraps = {
          wine = true;
          discord = true;
        };
      };
    };

    hid = {
      gamepad.dualsense.enable = true;
      tablet.enable = true;
    };
    graphics.nvidia.enable = true;

    audio = {
      pipewire = {
        enable = true;
        rtkit.enable = true;
        loopback.enable = true;
        compatibility.pulse.enable = true;
        compatibility.jack.enable = true;
      };
      mpdris.enable = true;
    };
    firewall.enable = true;
    network = {
      enable = true;
    };
    ssh = {
      enable = true;
      fail2ban = true;
    };

    bluetooth.enable = true;
    fonts = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.heavy-data
      nerd-fonts.jetbrains-mono
    ];

    keyboard = {
      layout = "us";
      variant = "";
    };

    bar.waybar = {
      enable = true;
      styleProfile = "jaesant";
    };

    de = {
      hyprland = {
        enable = true;
        autologin = false;
        utils.enable = true;
        styleProfile = "etherion";
        hypridle.enable = true;
        wlsunset.enable = true;
        wallpaper.enable = true;
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
            nohist = "unset HISTFILE";
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

    terminal.kitty = {
      enable = true;
      remoteControl = true;
      default = true;
    };

    printing = {
      enable = true;
      autodiscovery.enable = true;
    };
  };

  apps = {
    modules.all.enable = true; # Enables all apps under modules/apps
    bat.enable = true;
    audacity.enable = true;
    firefox = {
      arkenfox = true;
      vim.enable = false;
    };
    neovim = {
      aliases.enable = true;
      defaultEditor = true;
    };

    aseprite.enable = true;

    feishin.enable = true;
    godot.enable = true;
    #thunderbird.enable = true; #TODO: protonmail-bridge
    discord = {
      vencord.enable = true;
      moonlight.enable = false;
      openASAR.enable = true;
    };
    freecad.fem.enable = true;
    meshroom.enable = false;
    eza = {
      shellIntegration = true;
      overrides.shellIntegration.nushell.enable = false;
    };
    fzf.shellIntegration = true;
    zoxide.shellIntegration = true;
    carapace.shellIntegration = true;
    games.steam = {
      millennium.enable = false;
      compat = true;
      backup = true;
    };
    games.lutris.enable = false;
  };

  apps.beets.config = {
    directory = "/home/${main_user}/Music/songs/processed";
    asciify_paths = true;
    import = {
      write = true;
      copy = true;
      hardlink = false;
      group_albums = true;
      duplicate_verbose_prompt = true;
    };
    plugins = ["chroma" "mbsync" "lyrics" "replaygain" "lastgenre" "edit" "duplicates"];
    replaygain.backend = "ffmpeg";

    lyrics = {
      sources = ["lrclib"];
      force = true;
      synced = true;
    };

    paths = {
      default = "$albumartist/$album%aunique{}_$original_year/$artist-$album-$title";
      singleton = "$albumartist/$title_$original_year/$artist-$title";
      comp = "Compilations/$album%aunique{}/$track-$title";
    };
    match.distance_weights.missing_tracks = 0.0;
  };

  hosting = {
    openFirewall = true;
    ip = "192.168.0.69";
    defaultGroup = "server";
    monitor = true;

    bazarr.enable = true;
    calibre-web = {
      enable = true;
      proxy.enable = true;
      settings.allowUploads = true;
    };
    jellyfin = {
      enable = true;
      proxy.enable = true;
    };
    jellyseerr = {
      enable = true;
      proxy.enable = true;
    };
    karakeep = {
      enable = false;
      proxy.enable = true;
    };
    mealie = {
      enable = true;
      proxy.enable = true;
    };
    monit = {
      enable = true;
      proxy.enable = true;
      fileSystems = [
        {
          name = "Root";
          path = "/";
        }
        {
          name = "Media";
          path = "/mnt/priv/";
        }
        {
          name = "Games";
          path = "/mnt/Games/";
        }
        {
          name = "HDD";
          path = "/mnt/HDD/";
        }
      ];
    };
    mpd = {
      enable = false;
      directories = {
        music = "/home/${main_user}/Music/songs/";
        playlist = "/home/${main_user}/Music/songs/playlists/";
      };
      startWhenNeeded = false;
      user = "etherion";
    };
    navidrome = {
      enable = true;
      directories = {
        music = "/home/${main_user}/Music/songs/";
        #playlist = "playlists";
      };
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
    };
    proxy.enable = false;
    qbittorrent = {
      enable = true;
      port = 8081;
      defaultSavePath = "/mnt/priv/Media/qBittorrent";
      vuetorrent.enable = true;
    };
    radarr.enable = true;
    radicale = {
      enable = true;
      proxy.enable = true;
    };
    rustypaste = {
      enable = true;
      proxy.enable = true;
    };
    searxng = {
      enable = false;
      proxy.enable = true;
    };
    sonarr.enable = true;
    syncthing = {
      enable = true;
      config.directories = [
        {
          id = "ycnaw-dc4ex";
          label = "Music";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
          path = "/home/${main_user}/Music/songs";
        }
        {
          id = "rcnav-y6mqj";
          label = "Obsidian";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Documents/Obsidian";
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
          id = "wrgiw-yeh7e";
          label = "DCIM";
          devices = ["Pixel 8 Pro" "Laptop" "Main"];
          path = "/mnt/HDD/Bilder/DCIM";
        }
        {
          id = "wrfwn-ejec3";
          label = "Pictures";
          devices = ["Pixel 8 Pro" "Laptop" "Main"];
          path = "/mnt/HDD/Bilder/Pictures";
        }
        {
          id = "o0gxy-s1rof";
          label = "Whatsapp Media";
          devices = ["SM-A715F" "Pixel 8 Pro" "Laptop" "Main"];
          path = "/mnt/HDD/Bilder/Whatsapp Media";
          type = "receiveonly";
        }
        {
          id = "aci0b-orq3j";
          label = "University";
          devices = ["Pixel 8 Pro" "Laptop" "Main" "Hypnos"];
          path = "/home/${main_user}/Documents/School/University";
        }
      ];
    };
    tandoor = {
      enable = false;
      port = 8023;
      monitor.enable = false;
      proxy.enable = true;
    };
  };

  scripts = {
    motion_extraction.enable = true;
    snapchat.enable = true;
    compatibility.enable = true;
  };

  fileSystems."/mnt/Games" = {
    device = "dev/disk/by-uuid/3212add8-8af3-46c6-a739-cfc018bd72ac";
    fsType = "ext4";
  };

  boot.initrd.luks.devices.HDD.device = "/dev/disk/by-uuid/0161cbc2-6ac8-42b4-874e-74c95c494aa9";
  fileSystems."/mnt/HDD" = {
    device = "/dev/mapper/HDD";
  };

  boot.initrd.luks.devices.Priv.device = "/dev/disk/by-uuid/ef533879-a0c5-456a-8a91-db761e21ed63";
  fileSystems."/mnt/priv" = {
    device = "/dev/mapper/Priv";
  };
}
