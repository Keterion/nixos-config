{ config, lib, pkgs, inputs, ...}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.modules.apps.spotify = {
    enable = lib.mkEnableOption "the spotify desktop app";
    spicetify = {
      enable = lib.mkEnableOption "spicetify spotify theming";
      cli = lib.mkEnableOption "the spicetify cli app, imperative";
    };
  };
  
  config = lib.mkIf config.modules.apps.spotify.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
      home.packages = with pkgs; [
	unstable.spotify
      ];
    programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    lib.mkIf config.modules.apps.spotify.spicetify.enable {
      enable = true;
      spicetifyPackage = pkgs.unstable.spicetify-cli;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
