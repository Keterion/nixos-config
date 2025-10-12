{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "exiftool";
  package = pkgs.exiftool;
  inherit config;
}
