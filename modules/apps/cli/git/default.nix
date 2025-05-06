{ config, lib, pkgs, ... }:
let
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
    ];

    programs.git = {
      enable = true;
      config = {
	init.defaultBranch = cfg.defaultBranch;
      };
    };

    home-manager.users.${config.system.users.default.name}.programs.git = {
      enable = true;
      userEmail = config.system.users.default.git.email;
      userName = config.system.users.default.git.name;
    };
  };
}
