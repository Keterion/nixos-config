{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "mediainfo";
  package = pkgs.mediainfo;
  inherit config;
}
