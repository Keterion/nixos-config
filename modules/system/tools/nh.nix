{ lib, config, ...}:
let
  cfg = config.modules.system.tools.nh;
in {
  options.modules.system.tools.nh = {
    enable = lib.mkEnableOption "the nh tool";
    clean = lib.mkEnableOption "automatic removal of older versions";
  };
  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = cfg.clean;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "${config.users.users.${config.vars.globals.defaultUser.name}.home}/etc/nixos";
    };
  };
}
