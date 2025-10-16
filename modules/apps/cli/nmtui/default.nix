{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "nmtui";
  package = pkgs.networkmanager;
  inherit config;
}
