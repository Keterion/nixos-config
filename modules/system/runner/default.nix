{lib, ...}: {
  imports = [
    ./tofi.nix
  ];
  options.system.runner = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Name of the runner to use, set by the system";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Command for the runner, can be changed by the user";
    };
  };
}
