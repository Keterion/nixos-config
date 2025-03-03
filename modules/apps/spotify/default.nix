{ config, lib, pkgs, inputs, osConfig, ...}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.modules.apps = {
    spotify.enable = lib.mkEnableOption "the spotify desktop app";
    spicetify = {
      enable = lib.mkEnableOption "the spotify desktop app with theming";
      cli = lib.mkEnableOption "the spicetify cli app, imperative";
    };
  };
  
  config = {
    #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
    home.packages = with pkgs; lib.optionals config.modules.apps.spotify.enable [
      spotify
    ] ++ lib.optionals config.modules.apps.spicetify.cli [
      spicetify-cli
    ];
    programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    lib.mkIf config.modules.apps.spicetify.enable {
      enable = true;
      spotifyPackage = pkgs.spotify;

      theme = spicePkgs.themes.dribbblish;

      colorScheme = "custom";
      customColorScheme = with osConfig.vars.theming.colors; {
	text = "${fg}";
	subtext = "${fg_dark}";
	sidebar-text = "${fg_dark}";
	main = "${bg}";
	sidebar = "${bg_dark}";
	player = "${bg}";
	card = "${bg}";
	shadow = "${bg_dark}";
	selected-row = "${bg_dark}";
	button = "${purple}";
	button-active = "${purple}";
	button-disabled = "${red1}";
	tab-active = "${magenta}";
	notification = "${green}";
	notification-error = "${red2}";
	misc = "${fg_dark}";
      };
      enabledExtensions = with spicePkgs.extensions; [
	fullAppDisplay
	shuffle
	#adblock #doesn't seem to work
	adblockify
	playlistIcons
	beautifulLyrics
      ];
    };
  };
}
