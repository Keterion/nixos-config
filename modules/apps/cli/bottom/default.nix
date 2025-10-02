{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "bottom";
  package = pkgs.bottom;
  inherit config;
}
