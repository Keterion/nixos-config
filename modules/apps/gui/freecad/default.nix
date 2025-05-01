{ lib, pkgs, config, ... }:
let
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
    home-manager.users.${config.system.users.default.name}.home.packages = [
      pkgs.freecad
    ] ++ lib.optionals cfg.fem.enable [
      pkgs.calculix
      pkgs.gmsh
    ];
  };
}
