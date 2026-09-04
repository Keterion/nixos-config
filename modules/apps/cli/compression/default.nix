{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.compression.enable = lib.mkEnableOption "compression tools.";
  config = lib.mkIf config.apps.compression.enable {
    environment.systemPackages = with pkgs; [
      unzip
      p7zip
      unrar
    ];
  };
}
