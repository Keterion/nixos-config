{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.hosting.copyparty;
in {
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  options.hosting.copyparty = {
    enable = lib.mkEnableOption "copyparty";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [inputs.copyparty.overlays.default];
    services.copyparty.enable = true;
  };
}
