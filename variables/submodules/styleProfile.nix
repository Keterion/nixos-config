{ lib, ... }: {
  options = {
    profile = lib.mkOption {
      type = lib.types.enum[];
    };
  };
}
