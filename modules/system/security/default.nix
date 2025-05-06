{ config, lib, ... }: 
let
  cfg = config.system.security;
in {
  options.system.security = {
    gnupg.enableSSH = lib.mkEnableOption "ssh support for gnupg";
  };
  config = {
    security.polkit.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = cfg.gnupg.enableSSH;
    };
  };
}
