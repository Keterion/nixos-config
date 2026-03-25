{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.freecad;
in {
  options.apps.freecad = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.all.enable;
      type = lib.types.bool;
      description = "Whether to enable freecad";
    };
    fem.enable = lib.mkEnableOption "FEM tools and dependencies";
    # calculix, gmsh
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    home-manager.users.${config.sys.users.default.name}.home.packages =
      [
        pkgs.stable.freecad
      ]
      ++ lib.optionals cfg.fem.enable [
        pkgs.calculix-ccx
        pkgs.gmsh
      ];
  };
}
