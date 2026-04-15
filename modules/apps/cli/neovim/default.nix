{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.neovim;
in {
  options.apps.neovim = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.dev.enable;
      type = lib.types.bool;
      description = "Whether to enable neovim configured via nvf.";
    };
    aliases.enable = lib.mkEnableOption "aliases for vi";
    defaultEditor = lib.mkEnableOption "neovim as the default text editor";
  };

  config = lib.mkIf cfg.enable {
    environment.variables.EDITOR = lib.mkIf cfg.defaultEditor "nvim";

    programs.nvf = {
      enable = true;
      settings.vim = {
        theme = {
          enable = true;
          name = "tokyonight";
          style = "moon";
        };
        keymaps = [
          {
            key = "<C-n>";
            mode = "n";
            action = ":Neotree toggle left<CR>";
            silent = true;
            unique = true;
            nowait = true;
            desc = "Toggle tree as left sidebar";
          }
          {
            key = "<leader>s";
            mode = ["n"];
            action = ":AerialToggle right<CR>";
            silent = true;
            unique = true;
            nowait = true;
            desc = "Open aerial on right side";
          }
        ];

        utility.surround = {
          enable = true;
          useVendoredKeybindings = false;
        };
        utility.outline.aerial-nvim = {
          enable = true;
          #mappings.toggle = "<leader>s";
          setupOpts = {
            autojump = true;

            manage_folds = true;

            close_on_select = true;
          };
        };

        viAlias = cfg.aliases.enable;
        vimAlias = cfg.aliases.enable;

        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;

          autoindent = false;
        };

        mini.pairs = {
          enable = true;
          setupOpts = {
            mappings = {
              "$" = {
                action = "closeopen";
                pair = "$$";
                neigh_pattern = "[^\\].";
              };
            };
          };
        };
        #autopairs.nvim-autopairs = {
        #  enable = true;
        #  setupOpts = {

        #  };
        #};

        binds = {
          hardtime-nvim = {
            enable = true;
            setupOpts = {
              # key repetition
              max_time = 1000;
              max_count = 3;

              hint = true;
              disable_mouse = true;
            };
          };
          whichKey = {
            enable = true;
          };
        };

        filetree.neo-tree = {
          enable = true;
        };

        ui.colorizer.enable = true;

        snippets.luasnip = {
          enable = true;
          #  customSnippets.snipmate = lib.mkIf config.programs.nvf.settings.vim.languages.typst.enable {
          #    typst = [
          #      {
          #        trigger = "table";
          #        body = "#tablegcolumns:$1, table.header($2)g";
          #        description = "Generate a table";
          #      }
          #    ];
          #  };
        };

        statusline.lualine.enable = true;
        autocomplete.nvim-cmp.enable = true;
        lsp.formatOnSave = true;

        lsp.enable = true;
        languages = {
          rust = {
            enable = true;
            format.enable = true;
            lsp = {
              enable = true;
            };
            treesitter.enable = true;
          };
          nix = {
            enable = true;
            format = {
              enable = true;
            };
            lsp = {
              enable = true;
              servers = ["nil"];
            };
            treesitter.enable = true;
            extraDiagnostics.enable = true;
          };
          java = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          typst = {
            enable = true;
            format = {
              enable = true;
              type = ["typstyle"];
            };
            lsp.enable = true;
            treesitter.enable = true;
            extensions = {
              typst-preview-nvim.enable = true;
            };
          };
          markdown = {
            enable = false;
            extensions.markview-nvim = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
