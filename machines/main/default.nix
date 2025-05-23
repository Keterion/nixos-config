{
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "main";
  system.users.default = {
    name = "etherion";
    git = {
      name = "Keterion";
      email = "100532848+Keterion@users.noreply.github.com";
    };
    extraGroups = ["${config.hosting.defaultGroup}" "audio"];
  };
  system = {
    configDir = /home/${config.system.users.default.name}/etc/nixos;
    colorscheme = "tokyonight-moon";

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
      styleProfile = "haides002";
    };

    de = {
      hyprland = {
        enable = true;
        autologin = false;
        utils.enable = true;
        styleProfile = "etherion";
        hypridle.enable = true;
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

    terminal.kitty = {
      enable = true;
      remoteControl = true;
    };

    printing = {
      enable = true;
      autodiscovery.enable = true;
    };
  };

  apps = {
    modules.all.enable = true; # Enables all apps under modules/apps
    firefox = {
      arkenfox = true;
      vim.enable = false;
    };
    neovim = {
      aliases.enable = true;
      defaultEditor = true;
    };
    #thunderbird.enable = true; #TODO: protonmail-bridge
    discord.vencord.enable = true;
    freecad.fem.enable = true;
    eza = {
      shellIntegration = true;
      overrides.shellIntegration.nushell.enable = false;
    };
    fzf.shellIntegration = true;
    zoxide.shellIntegration = true;
    games.steam = {
      compat = true;
      backup = true;
    };
  };

  apps.beets.config = {
    directory = "/home/${config.system.users.default.name}/Music/songs";
    asciify_paths = true;
    import = {
      write = true;
      copy = true;
      hardlink = false;
      group_albums = true;
      duplicate_verbose_prompt = true;
    };
  };

  hosting = {
    openFirewall = true;
    ip = "192.168.178.69";
    defaultGroup = "server";
    monitor = true;

    bazarr.enable = true;
    calibre-web = {
      enable = true;
      proxy.enable = true;
    };
    jellyfin.enable = true;
    jellyseerr = {
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
      enable = true;
      directories = {
        music = "/home/${config.system.users.default.name}/Music/songs/";
        playlist = "/home/${config.system.users.default.name}/Music/songs/playlists/";
      };
      startWhenNeeded = true;
      user = "etherion";
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
    };
    proxy.enable = true;
    qbittorrent = {
      enable = true;
      port = 8081;
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
    sonarr.enable = true;
    syncthing.enable = true;
    tandoor = {
      enable = true;
      port = 8023;
      monitor.enable = false;
      proxy.enable = true;
    };
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
