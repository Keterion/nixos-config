{ lib, pkgs, config, ... }: {
  imports = [
    ./vpn.nix
    ./hosts.nix
  ];
}
