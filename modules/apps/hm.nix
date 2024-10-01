{ pkgs, lib, config, ...}:
{
  imports = [
    ./firefox
    ./spotify
    ./cava
    ./neovim
  ];
}
