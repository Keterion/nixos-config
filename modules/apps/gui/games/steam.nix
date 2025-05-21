{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.apps.games.steam;
in {
  options.apps.games.steam = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.games.enable;
      type = lib.types.bool;
      description = "Whether to enable .";
    };
    compat = lib.mkEnableOption "compatibility tools";
    backup = lib.mkEnableOption "ludusavi as a backup tool";
    remotePlay.openFirewall = lib.mkEnableOption "open firewall for remote play";
    dedicatedServer.openFirewall = lib.mkEnableOption "open firewall for dedicated servers";
    gamescopeSession.enable = lib.mkEnableOption "gamescope wayland sessions";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = cfg.remotePlay.openFirewall;
      dedicatedServer.openFirewall = cfg.dedicatedServer.openFirewall;
      gamescopeSession.enable = cfg.gamescopeSession.enable;
      extraCompatPackages = with pkgs;
        lib.mkIf cfg.compat [
          proton-ge-bin
        ];
      extraPackages = with pkgs;
        lib.mkIf cfg.compat [
          gamescope
          gamemode
        ];
    };
    environment.systemPackages = with pkgs;
      lib.optionals cfg.compat [
        protontricks
        wineWowPackages.staging
        winetricks
        gamescope
        gamemode
        mangohud
      ]
      ++ lib.optionals cfg.backup [
        pkgs.ludusavi
      ];
  };
}
