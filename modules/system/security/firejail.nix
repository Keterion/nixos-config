{
  lib,
  pkgs,
  myUtils,
  config,
  ...
}: let
  cfg = config.sys.security.firejail;
in {
  options.sys.security.firejail = {
    enable = lib.mkEnableOption "firejail for sandboxing";
    #wrappedBinaries = lib.mkOption {
    #  type = config.programs.firejail.wrappedBinaries.type;
    #  default = {};
    #};
    defaultWraps = {
      wine = myUtils.mkEnabledOption "Wine wrapping";
      discord = myUtils.mkEnabledOption "Discord wrapping";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firejail = {
      enable = true;
    };
  };
}
