{
  config,
  lib,
  ...
}: {
  config = {
    xdg.mime.defaultApplications = lib.mkMerge [
      (lib.mkIf
        config.apps.imv.enable
        {
          "image/*" = [
            "imv.desktop"
          ];
        })
      (lib.mkIf
        config.apps.zathura.enable
        {
          "application/pdf" = [
            "zathura.desktop"
          ];
        })
    ];
  };
}
