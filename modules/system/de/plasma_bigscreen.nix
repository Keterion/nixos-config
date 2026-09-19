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
  options.sys.de.plasma-bigscreen.enable = lib.mkEnableOption "plasma de for televisions";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    xdg.portal.configPackages = [bs_pkg];

    networking.networkmanager = {
      enable = true;
    };

    services.displayManager.sessionPackages = [bs_pkg];
  };
}
