# Structure
## Maximum config:
```nix
system = {
    audio.pipewire = {
        enable = true; # enabled by default
        rtkit.enable = true;
        compatibiliy = {
            pulse.enable = true;
            jack.enable = true;
        };
    };

    bar.waybar = {
        enable = true;
        styleProfile = "haides002";
    };

    de.hyprland = {
        enable = true;
        autologin = true;
        utils.enable = true;
        styleProfile = "etherion";
    };

    dm = {
        gdm = {
            enable = false;
            banner = ''
                Hello World!
            '';
            styleProfile = "default";
        };
        ly = {
            enable = false;
            styleProfile = "default";
        };
        sddm = {
            enable = true;
            styleProfile = "default";
        };
    };

    firewall = {
        enable = true; # enabled by default
        allowedTCPPorts = [ 8080 ];
        allowedUDPPorts = [ 8080 ];
    };

    fonts = [ pkgs.nerd-fonts.hack ];

    lockscreen.swaylock = { # link this to the lock shortcut in hyprland
        enable = true;
    };

    runner.tofi = {
        enable = true;
        styleProfile = "etherion";
    };

    security.gnupg.enableSSH = false;

    shell = {
        aliases = {
            l = "ls -la";
        };
        zsh = {
            enable = true;
            global = {
                autosuggestions.enable = true;
                aliases = {
                    la = "ls -lah";
                };
            };
            user = {
                autocd = enable;
                autosuggestion = {
                    enable = true;
                    highlight = "underline";
                };
                enableCompletion = true;
                aliases = {
                    hello = "world!";
                };
                history = {
                    ignoreDups = true; # enabled by default
                    ignoreSpace = true;
                    substringSearch = {
                        enable = true;
                        searchDownKey = "\\eOB";
                        searchUpKey = "\\eOA";
                    };
                };
            };
        };
    };

    colorscheme = "tokyonight-moon";

    users.default = {
        name = "etherion";
        extraGroups = [ "adbusers" "wheel" ];
    };

    keyboard = {
        layout = "us";
        variant = "";
    };
};
```
