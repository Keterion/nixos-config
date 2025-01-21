{ lib, ... }: {
  options.system.users.default = {
    name = lib.mkOption {
      type = lib.types.str;
      example = "etherion";
      description = "Username of the default user";
    };
  };
}
