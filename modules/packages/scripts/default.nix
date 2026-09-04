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
    ./api/wallhaven.nix
  ];
  options.scripts = {
    compatibility.enable = lib.mkEnableOption "NixOS compatibility scripts";
  };

  config = {
    environment.systemPackages =
      lib.optionals cfg.compatibility.enable [
        (pkgs.writeShellScriptBin "compat_run" ''
          if ${pkgs.steam-run}/bin/steam-run "./$1"; then
            echo "Ran using steam-run"
          elif ${inputs.nix-alien.packages."x86_64-linux".nix-alien}/bin/nix-alien "$1"; then
            echo "Ran using nix-alien"
          elif wine "$1"; then
            echo "Ran using wine."
          fi
        '')
      ]
      ++ [
        (pkgs.writeShellScriptBin "calc" ''
          res=$(${pkgs.calc}/bin/calc -m 0 -q -p $@)

          opt=$(${pkgs.coreutils}/bin/printf $res | ${pkgs.findutils}/bin/xargs ${pkgs.libnotify}/bin/notify-send -a "$@" -t 5000 --action='default=copy' "calc result")

          if [ "$opt" = "default" ]; then
            ${pkgs.wl-clipboard}/bin/wl-copy $res;
            ${pkgs.libnotify}/bin/notify-send -a "copied result" "";
          fi

        '')
      ];
  };
}
