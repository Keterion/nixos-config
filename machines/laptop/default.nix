{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
    wireless.enable = true;
  };

  #networking.wireless.networks = {
  #  eduroam = {
  #  };
  #};

  #laptop lid stuff here
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "lock";
  };

  #sops = {
  #  secrets = {
  #    "eduroam/password" = {};
  #    "eduroam/identity" = {};
  #  };
  #  templates."uni_vpn" = {
  #    content = ''
  #      username=${config.sops.placeholder."eduroam/identity"}
  #      password=${config.sops.placeholder."eduroam/password"}
  #    '';
  #  };
  #};

  #services.openvpn.servers = let
  #  mullvad = "${pkgs.mullvad-vpn}/bin/mullvad";
  #in {
  #  uni = {
  #    config = ''config /home/${config.sys.users.default.name}/.cert/uni/vun.ovpn '';
  #    autoStart = false;
  #    authUserPass = config.sops.templates."uni_vpn".path;
  #    updateResolvConf = false;
  #    up =
  #      lib.optionalString
  #      config.apps.mullvad-vpn.enable ''
  #        ${mullvad} disconnect
  #        ${mullvad} lockdown-mode set off
  #      '';
  #    down = lib.optionalString config.apps.mullvad-vpn.enable ''
  #      ${mullvad} reconnect
  #      ${mullvad} lockdown-mode set on
  #    '';
  #  };
  #};

  sys.users.default = {
    name = "etherion";
    extraGroups = ["networkmanager"];
    git = {
      name = "Keterion";
      email = "100532848+Keterion@users.noreply.github.com";
    };
  };
  sys = {
    configDir = /home/${config.sys.users.default.name}/etc/nixos;
    colorscheme = "tokyonight-moon";

    security = {
      secureboot = {
        setup.utils = true;
        setup.done = true;
        enable = true;
      };
      firejail = {
        enable = true;
        defaultWraps.firefox = false;
      };
    };

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
    network = {
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
        wallpaper.enable = true;
      };
      plasma.enable = false;
    };

    screenlocker.hyprlock.enable = true;

    #dm.sddm.enable = true;
    dm.ly.enable = true;

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

  scripts = {motion_extraction.enable = true;};
  apps = {
    modules.all.enable = false; # Enables all apps under modules/apps
    modules.cli.all.enable = true;
    bat.enable = true;
    typst.enable = true;
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
    mullvad-vpn.enable = true;

    imv.enable = true;
    betaflight.enable = false; # broken
    freecad.enable = true;
    gimp.enable = true;
    #thunderbird.enable = true; #TODO: protonmail-bridge
    discord = {
      enable = true;
      vencord.enable = true;
      openASAR.enable = false;
    };
    eza = {
      shellIntegration = true;
      overrides.shellIntegration.nushell.enable = false;
    };
    fzf.shellIntegration = true;
    zoxide.shellIntegration = true;
    games.steam = {
      enable = false;
      compat = true;
      backup = true;
    };
    valentina.enable = false;
  };
  apps.beets.config = {
    directory = "/home/${config.sys.users.default.name}/Music/songs/processed";
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

    copyparty = {
      enable = false;
      ip = "10.0.0.5";
      openFirewall = true;
    };
    syncthing = {
      enable = true;
      config.directories = let
        main_user = config.sys.users.default.name;
      in [
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
    firefox-syncserver = {
      enable = false;
      setFirefoxServer = true;
    };
    mpd = {
      enable = false;
      directories = {
        music = "/home/${config.sys.users.default.name}/Music/songs/";
        playlist = "/home/${config.sys.users.default.name}/Music/songs/playlists/";
      };
      startWhenNeeded = false;
      user = "${config.sys.users.default.name}";
    };
    navidrome = {
      enable = false;
      directories = {
        music = "/home/${config.sys.users.default.name}/Music/songs/";
        playlist = "/home/${config.sys.users.default.name}/Music/songs/playlists/";
      };
    };
  };
}
