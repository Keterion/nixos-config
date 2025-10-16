{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "ffmpeg";
  package = pkgs.ffmpeg;
  inherit config;
}
