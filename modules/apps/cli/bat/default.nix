{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "bat";
  package = pkgs.bat;
  inherit config;
}
