{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.scripts;
in {
  imports = [
    ./processing
  ];
  options.scripts = {
  };

  config = {
  };
}
