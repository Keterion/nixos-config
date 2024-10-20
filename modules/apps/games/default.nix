{ pkgs, lib, config, ...}: 
let
  cfg = config.modules.apps.games;
in
{
  imports = [
    ./steam.nix
    ./minecraft.nix
    ./osu.nix
    ./lutris.nix
    ./epicgames.nix
  ];

  options.modules.apps.games.enable = lib.mkEnableOption "all gaming modules";

  config = lib.mkIf cfg.enable {
    modules.apps.games = {
      steam = {
        enable = true;
	compat = true;
	remotePlay.openFirewall = false;
	dedicatedServer.openFirewall = true;
	gamescopeSession.enable = true;
      };
      minecraft.enable = true;
      osu.enable = true;
      lutris.enable = true;
      epicgames.enable = true;
    };
  };
}
