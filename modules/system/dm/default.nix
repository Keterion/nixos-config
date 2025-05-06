{ lib, config, ... }: {
  imports = [
    ./gdm.nix
    ./ly.nix
    ./sddm.nix
  ];

  #options.system.dm = {
  #  autoLogin = {
  #    enable = lib.mkEnableOption "autologin on supported dm";
  #    user = lib.mkOption {
  #      type = lib.types.str;
  #      default = config.system.users.default.name;
  #      description = "User for autologin";
  #    };
  #  };
  #  defaultSession = lib.mkOption {
  #    type = lib.types.nullOr lib.types.str;
  #    description = "Session to use for autoLogin, set to empty string for error message with all available sessions";
  #    default = null;
  #  };
  #};
  #
  #config = {
  #  services.displayManager.defaultSession = config.system.dm.defaultSession;
  #  services.displayManager.autoLogin = {
  #    enable = config.system.dm.autoLogin.enable;
  #    user = config.system.dm.autoLogin.user;
  #  };
  #};
}
