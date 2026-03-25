{
  pkgs,
  config,
  myUtils,
  lib,
  ...
}: let
  spotapi = pkgs.python3Packages.buildPythonPackage rec {
    pname = "spotapi";
    version = "1.2.7";
    format = "pyproject";
    build-system = [pkgs.python3Packages.setuptools];
    dependencies = with pkgs.python3Packages; [
      requests
      colorama
      pillow
      pyreaderwriterlock
      tls-client
      typing-extensions
      validators
      pyotp
      beautifulsoup4
    ];
    src = pkgs.fetchPypi {
      inherit version pname;
      format = "setuptools";
      sha256 = "c78500eb903852fc6a943379ba91ec3cf6b9caff20299c3792a2e8bbfd7156d6";
    };
  };
  spotipyfree = pkgs.python3Packages.buildPythonPackage rec {
    pname = "spotipyfree";
    version = "1.0.7";
    format = "pyproject";
    build-system = [pkgs.python3Packages.setuptools];
    nativeCheckInputs = with pkgs.python3Packages;
      [
        pymongo
      ]
      ++ [spotapi];
    src = pkgs.fetchPypi {
      inherit version pname;
      format = "setuptools";
      sha256 = "bb059dab1eb7295651b4eb7d51aec5217d14f227a2fedfb3e1e63ddbc80c5f5f";
    };
  };
  fuckass_package_set = with pkgs.python3Packages;
    [spotipyfree spotapi]
    ++ [
      beautifulsoup4
      fastapi
      mutagen
      platformdirs
      pydantic
      pykakasi
      python-slugify
      pytube
      pymongo
      rapidfuzz
      requests
      rich
      soundcloud-v2
      spotipy
      syncedlyrics
      uvicorn
      websockets
      yt-dlp
      ytmusicapi
    ];

  new_pkg =
    pkgs.spotdl.overrideAttrs
    (_old: {
      propagatedBuildInputs = fuckass_package_set;
      doCheck = false;
      #dependencies = fuckass_package_set;
      src = builtins.fetchGit {
        url = "https://github.com/TzurSoffer/spotify-downloader.git";
        ref = "master";
        rev = "02abed3e534ebd5c945c5359df78eba11d38b261";
      };
    });
in
  myUtils.mkSimpleOption {
    tree = "apps";
    name = "spotdl";
    #package = pkgs.spotdl;
    package = new_pkg.overridePythonAttrs (old: {
      doCheck = false;
    });
    inherit config;
  }
