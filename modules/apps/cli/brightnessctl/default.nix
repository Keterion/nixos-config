{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "brightnessctl";
  package = pkgs.brightnessctl;
  inherit config;
}
