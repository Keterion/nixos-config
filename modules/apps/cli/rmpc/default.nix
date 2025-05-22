{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.rmpc;
in {
  options.apps.rmpc = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
      description = "Whether to enable rmpc, a mpc client";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rmpc
    ];

    home-manager.users.${config.system.users.default.name}.programs.rmpc = {
      enable = true;
      config = ''
        (
          address: "${config.hosting.mpc.ip}:${toString config.hosting.mpc.port}",
          password: None,
          theme: None,
          wrap_navigation: false,
          enable_mouse: false,

          artists: (
            album_display_mode: NameOnly,
            album_sort_by: Name,
          )

          layout: Split(
            direction: Vertical,
            panes: [
              (
                size: "8",
                pane: Split(
                  direction: Horizontal,
                  panes: [
                    (
                      size: "21",
                      pane: Pane(AlbumArt),
                    ),
                    (
                      size: "100%",
                      pane: Split(
                        direction: Vertical,
                        panes: [
                          (
                            size: "5",
                            pane: Pane(Header),
                          ),
                          (
                            size: "1",
                            pane: Pane(ProgressBar),
                          ),
                          (
                            size: "3",
                            pane: Pane(Tabs),
                          ),
                        ]
                      )
                    ),
                  ]
                ),
              ]
            ),
        )
      '';
    };
  };
}
