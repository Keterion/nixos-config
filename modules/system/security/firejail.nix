{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.system.security.firejail;
in {
  options.system.security.firejail = {
    enable = lib.mkEnableOption "firejail for sandboxing";
    wrappedBinaries = config.programs.firejail.wrappedBinaries.type;
    defaultWraps = {
      wine = lib.myUtils.mkEnabledOption "Wine wrapping";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firejail = {
      enable = true;
      wrappedBinaries =
        lib.mkIf cfg.defaultWraps.wine {
          wine = {
            executable = "${lib.getBin pkgs.wine}/bin/wine";
            extraArgs = [
            ];
          };
        }
        // cfg.wrappedBinaries;
    };
  };
}
