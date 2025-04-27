{ lib, pkgs, config, ... }:
let
  cfg = config.apps.thunderbird;
in {
  options.apps.thunderbird = {
    enable = lib.mkEnableOption "thunderbird";
    protonmail.enable = lib.mkEnableOption "protonmail bridge"; #TODO
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.thunderbird
    ];
  };
}
