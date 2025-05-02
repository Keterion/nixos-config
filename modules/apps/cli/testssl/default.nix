{ lib, pkgs, config, ... }:
let
  cfg = config.apps.testssl;
in {
  options.apps.testssl.enable = lib.mkOption {
    default = config.apps.modules.cli.utils.enable;
    type = lib.types.bool;
    description = "Whether to enable testssl.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      testssl
    ];
  };
}
