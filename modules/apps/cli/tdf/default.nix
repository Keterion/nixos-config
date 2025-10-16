{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "tdf";
  package = pkgs.tdf;
  inherit config;
}
