{ pkgs, config, lib, ... }:
{
  imports = [
    ./git
    ./games
    ./office/libreoffice.nix
    ./cli
    ./thunderbird
  ];
}
