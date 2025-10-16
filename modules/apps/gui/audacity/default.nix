{
  config,
  pkgs,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  name = "audacity";
  package = pkgs.audacity;
  tree = "apps";
  inherit config;
}
