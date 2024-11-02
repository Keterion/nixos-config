{ lib, pkgs, config, ... }:
let
  cfg = config.modules.system.tools;
in {
  imports = [
    ./nh.nix
  ];
}
