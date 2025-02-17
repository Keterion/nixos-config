{ lib, ... }: {
  mkDisableOption = description: lib.mkOption {
    description = "Whether to disable ${description}";
    default = true;
    type = lib.types.bool;
  };
}
