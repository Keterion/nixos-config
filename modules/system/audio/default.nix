{
  config,
  lib,
  myUtils,
  pkgs,
  ...
}: let
  cfg = config.sys.audio;
in {
  options.sys.audio = {
    pipewire = {
      enable = myUtils.mkEnabledOption " the pipewire audio server";
      headless = lib.mkEnableOption "running pipewire headlessly";
      network = {
        host = {
          enable = lib.mkEnableOption "Pipewire sink to host ip";
          name = lib.mkOption {
            type = lib.types.str;
            default = "rtp-source";
          };
          port = lib.mkOption {
            type = lib.types.port;
          };
        };
        client = {
          enable = lib.mkEnableOption "Pipewire sink to host ip";
          name = lib.mkOption {
            type = lib.types.str;
            default = "rtp-sink";
          };
          destination = {
            ip = lib.mkOption {
              type = lib.types.str;
            };
            port = lib.mkOption {
              type = lib.types.port;
            };
          };
        };
      };
      rtkit.enable = lib.mkEnableOption " rtkit for realtime priority for pipewire";
      compatibility = {
        pulse.enable = lib.mkEnableOption " the pipewire-pulse audio server";
        jack.enable = lib.mkEnableOption " jack application audio support";
      };
      loopback.enable = lib.mkEnableOption "a loopback node"; # does nothing
    };
    mpdris.enable = lib.mkEnableOption "mpDris2 support for media control keys";
  };
  config = {
    environment.systemPackages = with pkgs;
      lib.optionals cfg.mpdris.enable [
        mpdris2
      ];
    services.pipewire = {
      enable = cfg.pipewire.enable;
      systemWide = cfg.pipewire.headless;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = cfg.pipewire.compatibility.pulse.enable;
      jack.enable = cfg.pipewire.compatibility.jack.enable;

      extraConfig.pipewire = {
        "20-rtp-sink" = lib.mkIf cfg.pipewire.network.client.enable {
          "context.modules" = [
            {
              name = "libpipewire-module-rtp-sink";
              args = {
                "destination.ip" = cfg.pipewire.network.client.destination.ip;
                "destination.port" = cfg.pipewire.network.client.destination.port;

                "stream.props" = {
                  "media.class" = "Audio/Sink";
                  "node.name" = cfg.pipewire.network.client.name;
                  "node.description" = "RTP Network Sink";

                  "audio.rate" = 48000;
                  "audio.channels" = 2;
                };
              };
            }
          ];
        };
        "20-rtp-source" = lib.mkIf cfg.pipewire.network.host.enable {
          "context.modules" = [
            {
              name = "libpipewire-module-rtp-source";
              args = {
                "local.ip" = "0.0.0.0";
                "local.port" = cfg.pipewire.network.host.port;

                "node.name" = cfg.pipewire.network.host.name;
                "node.description" = "RTP Network Source";

                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
                "audio.channels" = 2;
              };
            }
          ];
        };
      };
    };
    security.rtkit.enable = cfg.pipewire.rtkit.enable;
  };
}
