{ lib, pkgs, config, ...}: 
let
  cfg = config.modules.services.readarr;
in {
  options.modules.services.readarr = {
    enable = lib.mkEnableOption "readarr";
  };

  config = lib.mkIf cfg.enable {
    services.readarr = {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      openFirewall = lib.mkDefault config.modules.hosting.openFirewall;
      user = "readarr";
    };
  };
}
