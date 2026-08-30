{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.cargo.enable = lib.mkEnableOption "compression tools.";
  config = lib.mkIf config.apps.cargo.enable {
    environment.systemPackages = with pkgs; [
      unzip
      p7zip
      unrar
    ];
  };
}
