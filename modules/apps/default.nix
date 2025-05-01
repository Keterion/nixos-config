{ lib, ... }: {
  imports = [
    ./cli
    ./gui
  ];
  options.apps.modules.all.enable = lib.mkEnableOption "all app modules";
}
