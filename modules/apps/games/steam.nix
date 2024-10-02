{ pkgs, lib, config, ...}:
let
  cfg = config.modules.apps.games.steam;
in
{
  options.modules.apps.games.steam = {
    enable = lib.mkEnableOption "base steam";
    compat = lib.mkEnableOption "compatibility tools";
    backup = lib.mkEnableOption "ludusavi as a backup tool";
    remotePlay.openFirewall = lib.mkEnableOption "open firewall for remote play";
    dedicatedServer.openFirewall = lib.mkEnableOption "open firewall for dedicated servers";
    gamescopeSession.enable = lib.mkEnableOption "gamescoped steam option";

  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
	enable = true;
	remotePlay.openFirewall = cfg.remotePlay.openFirewall;
	dedicatedServer.openFirewall = cfg.dedicatedServer.openFirewall;
	gamescopeSession.enable = cfg.gamescopeSession.enable;
	extraCompatPackages = lib.mkIf cfg.compat [
	  pkgs.proton-ge-bin
	];
      };
      gamescope.enable = cfg.compat;
      gamemode.enable = cfg.compat;
    };
    environment.systemPackages = lib.optionals cfg.compat [
      pkgs.protontricks
      pkgs.wine64
      pkgs.winetricks
    ] ++ lib.optionals cfg.backup [
      pkgs.ludusavi
    ];
  };
}
