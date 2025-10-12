{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "nmap";
  package = pkgs.nmap;
  inherit config;
}
