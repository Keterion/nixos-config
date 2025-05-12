{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.rustypaste;
in {
  imports = [
    ../../packages/rustypaste-headless
  ];

  options.hosting.rustypaste = {
    enable = lib.mkEnableOption "rustypaste, a selfhosted pastebin";
    group = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.defaultGroup;
    };
    openFirewall = lib.mkOption {
      default = config.hosting.openFirewall;
      type = lib.types.bool;
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 8073;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.monitor;
    };
  };

  config = lib.mkIf cfg.enable {
    services.rustypaste = {
      enable = true;
      ip = "${cfg.ip}";
      openFirewall = cfg.openFirewall;
      port = cfg.port;
    };
  };
}
