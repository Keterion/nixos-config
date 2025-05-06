{
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "laptop";
  system.users.default = {
    name = "etherion";
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
    firewall.enable = true;
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

    terminal.kitty.enable = true;

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
  };

  hosting = {
    openFirewall = true;
    ip = "localhost";
    defaultGroup = "server";

    syncthing.enable = true;
  };
}
