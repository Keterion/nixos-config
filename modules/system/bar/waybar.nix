{ lib, config, ...}: 
let
  cfg = config.system.bar.waybar;
in {
  options.system.bar.waybar = {
    enable = lib.mkEnableOption " waybar";
    styleProfile = lib.mkOption {
      type = lib.types.enum["haides002" "default"];
      description = "Which style profile to load for waybar";
      # add default with globals somehow
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.vars.system.users.default.name} = {
      programs.waybar.enable = true;
      programs.waybar.settings = import ./waybar/${cfg.styleProfile}.nix;
    };
  };
}
