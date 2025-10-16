{
  inputs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "nix-alien";
  package = inputs.nix-alien.packages."x86_64-linux".nix-alien;
  inherit config;
}
