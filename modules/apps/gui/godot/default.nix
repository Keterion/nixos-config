{
  config,
  pkgs,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  name = "godot";
  package = pkgs.godot;
  tree = "apps";
  inherit config;
}
