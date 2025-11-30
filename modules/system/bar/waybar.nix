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
      type = lib.types.enum ["haides002" "default" "jaesant"];
      description = "Which style profile to load for waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    home-manager.users.${config.system.users.default.name}.imports = [
      ./waybar/${cfg.styleProfile}.nix
    ];
  };
}
