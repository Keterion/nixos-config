{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "tmux";
  package = pkgs.tmux;
  inherit config;
}
