{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.meshroom;
  meshroom_pkg = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "meshroom-bin";
    version = "2023.3.0";
    src = pkgs.fetchurl {
      url = "https://github.com/alicevision/meshroom/releases/download/v${version}/Meshroom-${version}-linux.tar.gz";
      hash = "sha256-krgSRjVt8/036gjh0JUZOSiXqqcwhD65/UvQWCkW05E=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      libsForQt5.wrapQtAppsHook
      makeWrapper
    ];

    buildInputs = with pkgs; [
      e2fsprogs
      glib
      krb5
      zlib
      postgresql
      unixODBC
      cups
      speechd
      python3
      libsForQt5.qt5.qtwebengine
      libsForQt5.qt5.qtwebview
      libsForQt5.qt5.qtwebsockets
      libsForQt5.qt5.qttools
      gtk3
      atk
      gdk-pixbuf
      cairo
      pango
      libdrm
      libGLU
      libglvnd
      libglvnd
      ocl-icd
      xorg.libX11
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libXxf86vm
    ];

    installPhase = ''
      mkdir -p $out/opt/meshroom
      cp -r \
        Meshroom \
        meshroom_batch \
        meshroom_compute \
        qtPlugins \
        lib \
        aliceVision \
        $out/opt/meshroom
      mkdir -p $out/bin
      makeWrapper $out/opt/meshroom/Meshroom $out/bin/Meshroom --chdir $out/opt/meshroom
      makeWrapper $out/opt/meshroom/meshroom_batch $out/bin/meshroom_batch --chdir $out/opt/meshroom
      makeWrapper $out/opt/meshroom/meshroom_compute $out/bin/meshroom_compute --chdir $out/opt/meshroom
    '';

    postFixup = ''
      patchelf --debug --add-needed libpython${pkgs.lib.versions.major pkgs.python3.pythonVersion}.so \
        "$out/opt/meshroom/Meshroom"
    '';
  };
in {
  options.programs.meshroom.enable = lib.mkEnableOption "Meshroom v2023.3.0";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        meshroom = meshroom_pkg;
      })
    ];
  };
}
