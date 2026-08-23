{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "cargo";
  package = pkgs.cargo;
  inherit config;
}
