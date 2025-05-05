{
  config,
  lib,
  myUtils,
  ...
}: let
  cfg = config.system.audio;
in {
  options.system.audio = {
    pipewire = {
      #enable = lib.mkEnableOption " the pipewire audio server";
      enable = myUtils.mkEnabledOption " the pipewire audio server";
      rtkit.enable = lib.mkEnableOption " rtkit for realtime priority for pipewire";
      compatibility = {
        pulse.enable = lib.mkEnableOption " the pipewire-pulse audio server";
        jack.enable = lib.mkEnableOption " jack application audio support";
      };
      loopback.enable = lib.mkEnableOption "a loopback node"; # does nothing
    };
  };
  config = {
    services.pipewire = {
      enable = cfg.pipewire.enable;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = cfg.pipewire.compatibility.pulse.enable;
      jack.enable = cfg.pipewire.compatibility.jack.enable;

      #extraConfig.pipewire."91-null-sinks" = lib.mkIf cfg.pipewire.loopback.enable {
      #  "context.objects" = [
      #    {
      #      factory = "adapter";
      #      args = {
      #        "factory.name" = "support.null-audio-sink";
      #        "node.name" = "loopback";
      #        "media.class" = "Audio/Sink";
      #        "audio.position" = "FL,FR";
      #        "monitor.channel-volumes" = "true";
      #        "monitor.passthrough" = "true";
      #        "adapter.auto-port-config" = {
      #          "mode" = "dsp";
      #          "monitor" = "true";
      #          "position" = "preserve";
      #        };
      #      };
      #    }
      #  ];
      #};
    };
    security.rtkit.enable = cfg.pipewire.rtkit.enable;
  };
}
