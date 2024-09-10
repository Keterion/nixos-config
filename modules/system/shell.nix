{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.system.shells;
in {
  imports = [
    ./shells/zsh.nix
  ];
  options.system.shells = {
    zsh = {
      enable = mkEnableOption "zsh";
      aliases = mkOption {
        type = types.attrsOf types.str;
	default = {};
	example = {ll = "ls -la";};
	description = "aliases for the zsh shell";
      };
    
