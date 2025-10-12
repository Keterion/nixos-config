{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "ripgrep";
  package = pkgs.ripgrep;
  inherit config;
}
