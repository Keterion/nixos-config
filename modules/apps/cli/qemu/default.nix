{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.qemu;
in {
  options.apps.qemu = {
    enable = lib.mkEnableOption "qemu virtualisation";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    environment.systemPackages = [pkgs.qemu];
  };
}
