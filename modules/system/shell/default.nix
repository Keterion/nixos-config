{
  config,
  lib,
  ...
}: {
  imports = [
    #    ./fsh.nix
    ./zsh.nix
    #    ./bash.nix
    ./prompt
  ];

  options.system.shell = {
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {ll = "ls -la";};
      description = "Aliases for all shells";
    };
  };

  config = {
    environment.shellAliases = config.system.shell.aliases;
  };
}
