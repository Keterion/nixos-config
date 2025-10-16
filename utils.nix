{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in {
  mkEnabledOption = name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };

  mkSimpleOption = {
    tree,
    name,
    package,
    extraConfig ? {},
    config,
  }: let
    attrsPath =
      (
        lib.splitStringBy (_: curr: builtins.elem curr ["."]) false "${tree}"
      )
      ++ ["${name}"];
    mkConfig = (lib.getAttrFromPath attrsPath config).enable;
  in {
    options = lib.setAttrByPath attrsPath {
      enable = lib.mkEnableOption "${name}";
    };

    config =
      lib.mkIf mkConfig {
        environment.systemPackages = [
          package
        ];
      }
      // lib.mkIf mkConfig extraConfig;
  };
}
