{
  config,
  lib,
  ...
}: let
  cfg = config.sys.security;
in {
  imports = [
    ./firejail.nix
    ./secureboot.nix
  ];
  options.sys.security = {
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
