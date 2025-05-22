{ lib, config, pkgs, ... }:
let
  cfg = config.apps.beets;
  yaml = pkgs.formats.yaml {};
in {
  options.apps.beets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.apps.modules.cli.utils.enable;
    };
    config = lib.mkOption {
      type = lib.types.nullOr yaml.type;
      default = null;
      description = "YAML config for beets written to $XDG_CONFIG_HOME/beets/config.yaml";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.system.users.default.name} = {
      programs.beets = {
        enable = true;
        settings = cfg.config;
      };
    };
  };
}
