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
            mode = ["n"];
            action = ":Neotree toggle left<CR>";
            silent = true;
            unique = true;
            nowait = true;
            desc = "Toggle tree as left sidebar";
          }
          {
            key = "<leader>s";
            mode = ["n" "v"];
            action = ":AerialToggle<CR>";
            silent = true;
            unique = true;
            nowait = true;
            desc = "Open aerial";
          }
        ];

        viAlias = cfg.aliases.enable;
        vimAlias = cfg.aliases.enable;

        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;

          autoindent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        filetree.neo-tree = {
          enable = true;
        };

        ui.colorizer.enable = true;

        statusline.lualine.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableLSP = true;

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
              server = "nil";
            };
            treesitter.enable = true;
            extraDiagnostics.enable = true;
          };
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          typst = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
        };
        extraPlugins = {
          aerial = {
            package = pkgs.vimPlugins.aerial-nvim;
            setup = "require('aerial').setup {}";
          };
        };
      };
    };
  };
}
