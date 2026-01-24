{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.ssh;
in {
  options.apps.ssh.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "Whether to enable tdf for viewing pdfs in supported terminals.";
  };
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = "
        Host local
          Hostname localhost
          Port ${builtins.toString config.sys.ssh.port}
          User etherion
      ";
    };
  };
}
