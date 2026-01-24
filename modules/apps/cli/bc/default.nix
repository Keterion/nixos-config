{
  pkgs,
  config,
  myUtils,
  ...
}:
myUtils.mkSimpleOption {
  tree = "apps";
  name = "bc";
  package = pkgs.bc;
  extraConfig = {
    sys.shell.aliases = {
      "bc" = "${pkgs.bc}/bin/bc -l";
    };
  };
  inherit config;
}
