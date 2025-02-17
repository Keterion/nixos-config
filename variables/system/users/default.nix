{ lib, config, ... }: 
let
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
  };
  config = {
    users.users.${cfg.default.name} = {
      extraGroups = cfg.default.extraGroups;
      home = "/home/${cfg.default.name}";
      isNormalUser = lib.mkDefault true;
      name = cfg.default.name;
    };
    home-manager.users.${cfg.default.name}.home = {
      stateVersion = config.system.stateVersion;
    };
  };
}
