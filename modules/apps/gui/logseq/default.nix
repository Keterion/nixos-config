{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "logseq";
  package = pkgs.logseq;
  extraConfig = {
  };
  inherit config;
}
