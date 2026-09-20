{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.de.plasma-bigscreen;
  bs_pkg = pkgs.kdePackages.plasma-bigscreen.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [pkgs.kdePackages.kdeconnect-kde];
    preFixup = ''
      wrapQtApp $out/bin/plasma-bigscreen-wayland \
        --prefix QML2_IMPORT_PATH : "${pkgs.kdePackages.kdeconnect-kde}/lib/qt-6/qml"
    '';
  });
in {
  options.sys.de.plasma-bigscreen = {
    enable = lib.mkEnableOption "plasma de for televisions";
    autologin = lib.mkEnableOption "automatically log into plasma bigscreen";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal.configPackages = [bs_pkg];

    networking.networkmanager = {
      enable = true;
    };
    services = {
      xserver.enable = true;
      displayManager = lib.mkMerge [
        (lib.mkIf cfg.autologin {
          autoLogin = {
            enable = true;
            user = config.sys.users.default.name;
          };
          defaultSession = "plasma-bigscreen";
        })
        {sessionPackages = [bs_pkg];}
      ];
    };
  };
}
