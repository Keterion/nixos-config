{
  config,
  lib,
  ...
}: let
  cfg = config.sys.runner.tofi;
in {
  options.sys.runner.tofi = {
    enable = lib.mkEnableOption "tofi";
    styleProfile = lib.mkOption {
      type = lib.types.enum ["etherion"];
      default = "etherion";
      description = "The style profile to use for tofi theming";
    };
  };

  config = lib.mkIf cfg.enable {
    sys.runner.command = "tofi-run";
    home-manager.users.${config.sys.users.default.name} = {
      programs.tofi.enable = true;
      imports = [
        ./tofi/${cfg.styleProfile}.nix
      ];
    };
  };
}
