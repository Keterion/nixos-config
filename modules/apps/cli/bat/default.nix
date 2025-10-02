{
  lib,
  pkgs,
  config,
  myUtils,
  ...
}: let
  cfg = config.apps.bat;
in
  myUtils.mkSimpleOption {
    tree = "apps";
    name = "bat";
    package = pkgs.bat;
  }
