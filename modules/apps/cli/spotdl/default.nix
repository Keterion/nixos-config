{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "spotdl";
  package = pkgs.spotdl;
  inherit config;
}
