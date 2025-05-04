{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.nh;
in {
  options.apps.nh = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
    };
    clean = lib.mkEnableOption "automatic cleaning";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nh
    ];
    home-manager.users.${config.system.users.default.name}.programs.nh = {
      enable = true;
      clean.enable = cfg.clean;
      clean.extraArgs = "--keep-since 7d";
      flake = "/home/etherion/etc/nOwOs";
    };
  };
}
