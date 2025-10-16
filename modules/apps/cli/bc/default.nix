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
    system.shell.aliases = {
      "bc" = "${pkgs.bc}/bin/bc -l";
    };
  };
  inherit config;
}
