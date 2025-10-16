{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "rsync";
  package = pkgs.rsync;
  inherit config;
}
