{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.git;
in {
  options.apps.git = {
    enable = lib.mkOption {
      default = config.apps.modules.cli.dev.enable;
      type = lib.types.bool;
      description = "Whether to enable git.";
    };
    defaultBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      example = "trunk";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      gh
    ];

    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = cfg.defaultBranch;
        #safe.directory = config.system.configDir;
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };

    home-manager.users.${config.sys.users.default.name}.programs = {
      git = {
        enable = true;
        settings.user = {
          name = config.sys.users.default.git.name;
          email = config.sys.users.default.git.email;
        };
      };
      gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };
    };
  };
}
