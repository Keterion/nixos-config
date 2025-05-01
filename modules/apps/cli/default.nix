{ config, lib, ... }:
let
  cfg = config.apps.modules.cli;
in {
  imports = [
    ./cava
    ./neovim
    ./git
    ./spotdl
  ];

  options.apps.modules.cli = {
    all.enable = lib.mkOption {
      default = config.apps.modules.all.enable; # All modules, gui and cli
      type = lib.types.bool;
      description = "Whether to enable all cli programs";
    };
    dev.enable = lib.mkOption {
      default = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable dev programs";
    };
    dl.enable = lib.mkOption {
      defalt = cfg.all.enable;
      type = lib.types.bool;
      description = "Whether to enable download programs";
    };
  };

  config = {
    apps.git.enable = lib.mkDefault cfg.dev.enable;
    apps.neovim.enable = lib.mkDefault cfg.dev.enable;

    apps.spotdl.enable = lib.mkDefault cfg.dl.enable;
  };
}
