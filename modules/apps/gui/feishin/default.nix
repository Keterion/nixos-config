{
  config,
  pkgs,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  name = "feishin";
  package = pkgs.feishin;
  tree = "apps";
  inherit config;
}
