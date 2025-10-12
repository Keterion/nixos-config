{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "encfs";
  package = pkgs.encfs;
  inherit config;
}
