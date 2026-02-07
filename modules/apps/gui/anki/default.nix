{
  config,
  pkgs,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  name = "anki";
  package = pkgs.anki;
  tree = "apps";
  inherit config;
}
