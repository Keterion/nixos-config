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
    tree ? "",
    name,
    package,
  }: rec {
    options.${tree}.${name}.enable = lib.mkEnableOption "${name}";

    config = lib.mkIf options.${tree}.${name}.enable {
      environment.systemPackages = [
        package
      ];
    };
  };
}
