{
  lib,
  config,
  ...
}: let
  cfg = config.hosting.whisper;
in {
  options.hosting.whisper = {
    enable = lib.mkEnableOption "faster-whisper AI implementation";
    port = lib.mkOption {
      type = lib.types.port;
      default = 10300;
    };
    ip = lib.mkOption {
      type = lib.types.str;
      default = config.hosting.ip;
    };
  };

  config = lib.mkIf cfg.enable {
    services.wyoming.faster-whisper.servers = {
      default = {
        enable = true;
        device = "auto";
        uri = "tcp://${cfg.ip}:${toString cfg.port}";
        language = "jp";
        model = "medium-int8";
      };
    };
  };
}
