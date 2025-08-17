{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.apps.nix-alien;
in {
  options.apps.nix-alien.enable = lib.mkOption {
    description = "Whether to enable nix-alien";
    type = lib.types.bool;
    default = config.apps.modules.cli.utils.enable;
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with inputs.nix-alien.packages."x86_64-linux"; [
      nix-alien
    ];
  };
}
