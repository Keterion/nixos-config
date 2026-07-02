{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "gocryptfs";
  package = pkgs.gocryptfs;
  inherit config;
}
