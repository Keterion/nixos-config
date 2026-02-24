{
  config,
  lib,
  pkgs,
  myUtils,
  ...
}: let
  cfg = config.apps.discord;
in {
  options.apps.discord = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.social.enable;
      type = lib.types.bool;
      description = "Whether to enable discord";
    };
    sandbox = lib.mkOption {
      type = lib.types.bool;
      default = config.sys.security.firejail.defaultWraps.discord;
    };
    vencord.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to patch discord with vencord";
    };
    moonlight.enable = lib.mkEnableOption "patch discord with moonlight";
    openASAR.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to replace the discord .asar file with openASAR";
    };
  };

  config = let
    discord_package = pkgs.discord.override {
      withVencord = cfg.vencord.enable;
      withMoonlight = cfg.moonlight.enable;
      withOpenASAR = cfg.openASAR.enable;
    };
  in
    lib.mkIf cfg.enable {
      programs.firejail.wrappedBinaries.discord = lib.mkIf cfg.sandbox {
        executable = "${discord_package}/bin/discord";
        extraArgs = [
          "--dbus-user.talk=org.freedesktop.StatusNotifierHost"
          "--dbus-user.talk=org.kde.StatusNotifierWatcher"
          "--dbus-user.talk=org.freedesktop.portal.Desktop"
        ];
      };
      environment.systemPackages = lib.mkIf (!cfg.sandbox) [
        discord_package
      ];
    };
}
