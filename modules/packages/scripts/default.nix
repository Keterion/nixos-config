{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.scripts;
in {
  imports = [
    ./processing
  ];
  options.scripts = {
    compatibility.enable = lib.mkEnableOption "NixOS compatibility scripts";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.compatibility.enable [
      (pkgs.writeShellScriptBin "compat_run" ''
        if ${pkgs.steam-run}/bin/steam-run ./$1; then
          echo "Ran using steam-run"
        elif ${inputs.nix-alien.packages."x86_64-linux".nix-alien}/bin/nix-alien $1; then
          echo "Ran using nix-alien"
        elif wine $1; then
          echo "Ran using wine."
        fi
      '')
    ];
  };
}
