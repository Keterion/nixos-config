{ pkgs, lib, config, ...}: 
let
  cfg = config.modules.apps.games;
in
{
  imports = [
    ./steam.nix
    ./minecraft.nix
    ./osu.nix
  ];

  options.modules.apps.games.enable = lib.mkEnableOption "all gaming modules";

  config = lib.mkIf cfg.enable {
    modules.apps.games.steam = {
      enable = true;
      compat = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
    modules.apps.games.minecraft.enable = true;
    modules.apps.games.osu.enable = true;
  };
}
