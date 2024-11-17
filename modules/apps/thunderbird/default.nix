{ lib, pkgs, config, ...}: {
  options.modules.apps.thunderbird = {
    enable = lib.mkEnableOption "Mozilla Thunderbird";
    protonmail.enable = lib.mkEnableOption "Protonmail compatibility";
  };

  config = lib.mkIf config.modules.apps.thunderbird.enable {
    home-manager.users.${config.vars.globals.defaultUser.name}.home.packages = [ pkgs.thunderbird ];
    services.protonmail-bridge.enable = config.modules.apps.thunderbird.protonmail.enable;   
  };
}
