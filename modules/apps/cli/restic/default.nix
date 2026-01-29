{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "restic";
  package = pkgs.restic;
  inherit config;
}
