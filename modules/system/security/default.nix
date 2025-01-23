{ config, lib, ... }: 
let
  cfg = config.system.security;
in {
  options.system.security = {
    gnupg.enableSSH = lib.mkEnableOption "ssh support for gnupg";
  };
  config = {
    services.polkit.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = cfg.gnupg.enableSSH;
    };
  };
}
