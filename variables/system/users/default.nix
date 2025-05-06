{
  lib,
  config,
  ...
}: let
  cfg = config.system.users;
in {
  options.system.users.default = {
    name = lib.mkOption {
      type = lib.types.str;
      example = "etherion";
      description = "Username of the default user";
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra groups to give to the user";
    };
    git = {
      email = lib.mkOption {
        type = lib.types.str;
        description = "Email to use for git";
        example = "john.doe@example.com";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name to use for git";
        default = config.system.users.default.name;
        example = "John Doe";
      };
    };
  };
  config = {
    users.users.${cfg.default.name} = {
      extraGroups = ["wheel"] ++ cfg.default.extraGroups;
      home = "/home/${cfg.default.name}";
      isNormalUser = lib.mkDefault true;
      name = cfg.default.name;
      uid = 1000;
    };
    home-manager.users.${cfg.default.name}.home = {
      stateVersion = config.system.stateVersion;
    };
  };
}
