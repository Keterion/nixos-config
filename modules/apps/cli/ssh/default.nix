{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.ssh;
in {
  options.apps.ssh.enable = lib.mkOption {
    default = config.apps.modules.cli.media.enable;
    type = lib.types.bool;
    description = "Whether to enable tdf for viewing pdfs in supported terminals.";
  };
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      extraConfig = "
        Host local
          Hostname localhost
          Port ${builtins.toString config.system.ssh.port}
          User etherion
      ";
    };
  };
}
