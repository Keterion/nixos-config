{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.cargo.enable = lib.mkEnableOption "cargo.";
  config = lib.mkIf config.apps.cargo.enable {
    environment.systemPackages = with pkgs; [
      cargo
      gcc
      rustc
      bacon
      clippy
    ];
  };
}
