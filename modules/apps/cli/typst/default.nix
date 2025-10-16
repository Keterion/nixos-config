{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "typst";
  package = pkgs.typst;
  inherit config;
}
