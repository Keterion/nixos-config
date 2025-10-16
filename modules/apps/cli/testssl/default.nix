{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "testssl";
  package = pkgs.testssl;
  inherit config;
}
