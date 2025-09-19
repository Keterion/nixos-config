{
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "laptop";
  networking.networkmanager.enable = true;
  system.users.default = {
    name = "etherion";
    extraGroups = ["networkmanager"];
    git = {
      name = "Keterion";
      email = "100532848+Keterion@users.noreply.github.com";
    };
  };
  system = {
    configDir = /home/${config.system.users.default.name}/etc/nixos;
    colorscheme = "tokyonight-moon";

    audio.pipewire = {
      enable = true;
      rtkit.enable = true;
      loopback.enable = true;
      compatibility.pulse.enable = true;
      compatibility.jack.enable = true;
    };
    graphics.intel = {
      enable = true;
      old.enable = false;
    };
    firewall.enable = true;
    networking = {
      enable = true;
    };
    bluetooth.enable = true;
    fonts = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.heavy-data
      nerd-fonts.jetbrains-mono
    ];

    keyboard = {
      layout = "us";
      variant = "dvorak";
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
        hyprpaper.enable = true;
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
      default = true;
    };

    printing = {
      enable = true;
      autodiscovery.enable = true;
    };
  };

  apps = {
    modules.all.enable = false; # Enables all apps under modules/apps
    modules.cli.all.enable = true;
    firefox = {
      enable = true;
      arkenfox = true;
      vim.enable = false;
      searchEngine = "Brave";
    };
    modules.gui = {
      social.enable = true;
      media.enable = true;
      utils.enable = true;
      misc.enable = true;
    };
    neovim = {
      aliases.enable = true;
      defaultEditor = true;
    };
    mullvad-vpn.enable = false;

    betaflight.enable = false; # broken
    freecad.enable = true;
    gimp.enable = true;
    #thunderbird.enable = true; #TODO: protonmail-bridge
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
    games.steam = {
      enable = true;
      compat = true;
      backup = true;
    };
    valentina.enable = true;
  };
  apps.beets.config = {
    directory = "/home/${config.system.users.default.name}/Music/songs/processed";
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

    paths = {
      default = "$albumartist/$album%aunique{}_$original_year/$artist-$album-$title";
      singleton = "$albumartist/$title_$original_year/$artist-$title";
      comp = "Compilations/$album%aunique{}/$track-$title";
    };
    match.distance_weights.missing_tracks = 0.0;
  };

  hosting = {
    openFirewall = false;
    ip = "localhost";
    defaultGroup = "server";

    copyparty.enable = true;
    syncthing.enable = true;
    firefox-syncserver = {
      enable = false;
      setFirefoxServer = true;
    };
    mpd = {
      enable = true;
      directories = {
        music = "/home/${config.system.users.default.name}/Music/songs/";
        playlist = "/home/${config.system.users.default.name}/Music/songs/playlists/";
      };
      startWhenNeeded = false;
      user = "${config.system.users.default.name}";
    };
    navidrome = {
      enable = true;
      directories = {
        music = "/home/${config.system.users.default.name}/Music/songs/";
        playlist = "/home/${config.system.users.default.name}/Music/songs/playlists/";
      };
    };
  };
}
