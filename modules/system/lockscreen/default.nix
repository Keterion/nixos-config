{lib, ...}: {
  imports = [
    ./swaylock.nix
    ./hyprlock.nix
  ];

  options.sys.screenlocker = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Screenlocker to use, set by system based on enabled screenlocker";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Command for the screenlocker";
    };
  };
}
