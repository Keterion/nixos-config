{ inputs, ... }: 
let
  lib = inputs.nixpkgs.lib;
in {
  mkEnabledOption = name: lib.mkOption {
    default = true;
    example = false;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };
}
