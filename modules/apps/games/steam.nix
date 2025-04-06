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
	extraPackages = with pkgs; lib.mkIf cfg.compat [
	  gamescope
	  gamemode
	];
      };
    };
    environment.systemPackages = lib.optionals cfg.compat [
      pkgs.protontricks
      pkgs.wine64
      pkgs.winetricks
      pkgs.r2mod_cli
    ] ++ lib.optionals cfg.backup [
      pkgs.ludusavi
    ];
    environment.variables = {
      R2MOD_INSTALL_DIR = "/mnt/Games/Platforms/Steam/steamapps/common/Risk of Rain 2";
      R2MOD_COMPAT_DIR = "/mnt/Games/Platforms/Steam/steamapps/compatdata/632360";
    };
  };
}
