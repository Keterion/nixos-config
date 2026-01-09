{
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "Hypnos";
  system.users.default = {
    name = "Hypnos";
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
    configDir = /home/${config.system.users.default.name}/nixos;
    colorscheme = "tokyonight-moon";
    #sops.age.keyFile = "/home/Hypnos/.config/sops/age/keys.txt";

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
    networking = {
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
    ip = "localhost";
    defaultGroup = "server";

    #copyparty.enable = true;
    syncthing.enable = true;
    firefox-syncserver = {
      enable = false;
      setFirefoxServer = true;
    };
    mpd = {
      enable = false;
      directories = {
        music = "/home/${config.system.users.default.name}/Music/songs/";
        playlist = "/home/${config.system.users.default.name}/Music/songs/playlists/";
      };
      startWhenNeeded = false;
      user = "${config.system.users.default.name}";
    };
    navidrome = {
      enable = false;
      directories = {
        music = "/home/${config.system.users.default.name}/Music/songs/";
        playlist = "/home/${config.system.users.default.name}/Music/songs/playlists/";
      };
    };
  };
}
