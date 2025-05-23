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

    home-manager.users.${config.system.users.default.name} = {
      xdg.configFile."rmpc/themes/default.ron".text = with config.system.colors; ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (   
          default_album_art_path: None,
          draw_borders: false,
          show_song_table_header: true,
          symbols: (song: "S", dir: "D", marker: "M"),
          layout: Split(
            direction: Vertical,
            panes: [
              (
                size: "10",
                borders: "ALL",
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
                            size: "3",
                            pane: Pane(Tabs),
                          ),
                        ]
                      )
                    ),
                  ]
                ),
              ),
              (
                size: "100%",
                pane: Pane(TabContent),
                borders: "TOP | BOTTOM | LEFT | RIGHT",
              ),
            ],
          ),
          progress_bar: (
            symbols: ["", ">", "-"],
            track_style: (bg: "#${bg}"),
            elapsed_style: (fg: "#${purple}", bg: "#${bg}"),
            thumb_style: (fg: "#${purple}", bg: "#${bg}"),
          ),
          scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (),
            ends_style: (),
            thumb_style: (fg: "#${fg}"),
          ),
          browser_column_widths: [20, 38, 42],
          text_color: "#${fg_dark}",
          background_color: "#${bg_dark}",
          header_background_color: "#${bg}",
          modal_background_color: None,
          modal_backdrop: false,
          tab_bar: (active_style: (fg: "black", bg: "#${purple}", modifiers: "Bold"), inactive_style: ()),
          borders_style: (fg: "#${fg_dark}"),
          highlighted_item_style: (fg: "#${purple}", modifiers: "Bold"),
          current_item_style: (fg: "black", bg: "#${fg}", modifiers: "Bold"),
          highlight_border_style: (fg: "#${fg}"),
          song_table_format: [
            (
              prop: (kind: Property(Artist), style: (fg: "#${fg}"), default: (kind: Text("Unknown"))),
              width: "20%",
            ),
            (
              prop: (kind: Property(Title), style: (fg: "#${cyan}"), default: (kind: Text("Unknown"))),
              width: "35%",
            ),
            (
              prop: (kind: Property(Album), style: (fg: "#${cyan}"), default: (kind: Text("Unknown"))),
              width: "30%",
            ),
            (
              prop: (kind: Property(Duration), style: (fg: "#${cyan}"), defalut: (kind: Text("Unknown"))),
              width: "15%",
              alignment: Right,
            ),
          ],
          header: (
            rows: [
              (
                left: [
                  (kind: Text("["), style: (fg: "#${fg}", modifiers: "Bold")),
                  (kind: Property(Status(State)), style: (fg: "#${fg}", modifiers: "Bold")),
                  (kind: Text("]"), style: (fg: "#${fg}", modifiers: "Bold"))
                ],
                center: [
                  (
                    kind: Property(Song(Artist)),
                    style: (fg: "#${yellow}", modifiers: "Bold"),
                    default: (
                      kind: Text("Unknown"),
                      style: (fg: "#${yellow}", modifiers: "Bold")
                    )
                  ),
                ],
                right: [
                    (kind: Text("Vol: "), style: (fg: "#${fg}", modifiers: "Bold")),
                    (kind: Property(Status(Volume)), style: (fg: "#${fg}", modifiers: "Bold")),
                    (kind: Text("% "), style: (fg: "#${fg}", modifiers: "Bold"))
                ]
              ),
              (
                left: [
                  (kind: Property(Status(Elapsed))),
                  (kind: Text(" / ")),
                  (kind: Property(Status(Duration))),
                ],
                center: [
                  (kind: Property(Song(Title)), style: (fg: "#${cyan}", modifiers: "Bold"))
                ],
                right: [
                  (
                    kind: Property(Widget(States(
                      active_style: (fg: "#${fg}", modifiers: "Bold"),
                      separator_style: (fg: "#${fg}")))
                    ),
                    style: (fg: "#${fg_dark}"),
                  )
                ]
              ),
            ],
          ),
        )'';
      programs.rmpc = {
        enable = true;
        config = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
            address: "${config.hosting.mpd.ip}:${toString config.hosting.mpd.port}",
            password: None,
            wrap_navigation: false,
            enable_mouse: false,

            artists: (
              album_display_mode: NameOnly,
              album_sort_by: Name,
            ),
            theme: Some("default"),
            tabs: [
              (
                name: "Queue",
                pane: Pane(Queue),
              ),
              (
                name: "Directories",
                pane: Pane(Directories),
              ),
              (
                name: "Artists",
                pane: Pane(Artists),
              ),
              (
                name: "Album Artists",
                pane: Pane(AlbumArtists),
              ),
              (
                name: "Albums",
                pane: Pane(Albums),
              ),
              (
                name: "Playlists",
                pane: Pane(Playlists),
              ),
              (
                name: "Search",
                pane: Pane(Search),
              ),
            ],
          )
        '';
      };
    };
  };
}
