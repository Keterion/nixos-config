{
  config,
  lib,
  ...
}: {
  config = {
    xdg.mime.defaultApplications = lib.mkIf config.apps.imv.enable {
      "image/*" = [
        "imv.desktop"
      ];
    };
  };
}
