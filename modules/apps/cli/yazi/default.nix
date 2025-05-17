{
  lib,
  config,
  ...
}: let
  cfg = config.apps.yazi;
in {
  options.apps.yazi = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.utils.enable;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf {
    programs.yazi = {
      enable = true;
      settings = {
        theme = with config.system.colors; {
          manager = {
            cwd = {
              fg = "#${green}";
            };
            #Hovered
            hovered.reversed = true;
            preview_hovere.underline = true;
            # Find
            find_keyword = {
              fg = "#${yellow}";
              bold = true;
              italic = true;
              underline = true;
            };
            find_position = {
              fg = "#${purple}";
              bg = "reset";
              bold = true;
              italic = true;
            };

            # Marker
            marker_copied = {
              fg = "#${green}";
              gf = "#${green}";
            };
            marker_cut = {
              fg = "#${red}";
              bg = "#${red}";
            };
            marker_marked = {
              fg = "#${cyan}";
              bg = "#${cyan}";
            };
            marker_selected = {
              fg = "#${yellow}";
              bg = "#${yellow}";
            };

            # Tab
            tab_active.reversed = true;
            tab_inactive = {};
            tab_width = 1;

            # Count
            count_copied = {
              fg = "#${bg}";
              bg = "#${green}";
            };
            count_cut = {
              fg = "#${bg}";
              bg = "#${red}";
            };
            count_selected = {
              fg = "#${bg}";
              bg = "#${yellow}";
            };

            # Border
            border_symbol = "";
            border_style.fg = "#${fg_dark}";

            mode = {
              normal_main = {
                fg = "#${bg}";
                bg = "#${blue}";
                bold = true;
              };
              normal_alt = {
                fg = "#${blue}";
                bg = "#${bg}";
              };

              # Select mode
              select_main = {
                fg = "#${bg}";
                bg = "#${cyan}";
                bold = true;
              };
              select_alt = {
                fg = "#${cyan}";
                bg = "#${bg}";
              };

              # Unset mode
              unset_main = {
                fg = "#${bg}";
                bg = "#${purple}";
                bold = true;
              };
              unset_alt = {
                fg = "#${purple}";
                bg = "#${bg}";
              };
            };

            status = {
              # Permissions
              perm_sep.fg = "#${fg_dark}";
              perm_type.fg = "#${blue}";
              perm_read.fg = "#${yellow}";
              perm_write.fg = "#${red}";
              perm_exec.fg = "#${green}";

              # Progress
              progress_label = {
                fg = "#${fg}";
                bold = true;
              };
              progress_normal = {
                fg = "#${blue}";
                bg = "#${bg}";
              };
              progress_error = {
                fg = "#${red}";
                bg = "#${bg}";
              };
            };

            pick = {
              border.fg = "#${blue}";
              active = {
                fg = "#${purple}";
                bold = true;
              };
              inactive = {};
            };

            input = {
              border.fg = "#${blue}";
              title = {};
              value = {};
              selected.reversed = true;
            };

            cmp.border.fg = "#${blue}";

            tasks = {
              border.fg = "#${blue}";
              title = {};
              hovered = {
                fg = "#${purple}";
                underline = true;
              };
            };

            which = {
              mask.bg = "#${bg}";
              cand.fg = "#${cyan}";
              rest.fg = "#${fg_dark}";
              desc.fg = "#${purple}";
              separator = " >";
              separator_style.fg = "#${fg_dark}";
            };

            help = {
              on.fg = "#${cyan}";
              run.fg = "#${red}";
              hovered = {
                reversed = true;
                bold = true;
              };
              footer = {
                fg = "#${bg}";
                bg = "${fg}";
              };
            };

            notify = {
              title_info.fg = "#${green}";
              title_warn.fg = "#${yellow}";
              title_error.fg = "#${red}";
            };
          };
        };
      };
    };
  };
}
