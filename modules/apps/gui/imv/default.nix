{
  config,
  pkgs,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  name = "imv";
  package = pkgs.imv;
  tree = "apps";
  inherit config;
}
