{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.system.bar.waybar;
in {
  options.system.bar.waybar = {
    enable = lib.mkEnableOption " waybar";
    styleProfile = lib.mkOption {
      type = lib.types.enum ["haides002" "default"];
      description = "Which style profile to load for waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name} = {
      programs.waybar = import ./waybar/${cfg.styleProfile}.nix;

      home.packages = [pkgs.pavucontrol];
    };
  };
}
