{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "yt-dlp";
  package = pkgs.yt-dlp;
  inherit config;
}
