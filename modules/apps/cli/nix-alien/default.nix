{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "nix-alien";
  package = pkgs.nix-alien;
  inherit config;
}
