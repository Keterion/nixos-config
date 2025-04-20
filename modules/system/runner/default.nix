{ lib, ... }: {
  imports = [
    ./default.nix
  ];

  options.system.runner.command = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Command to run";
  };
}
