{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.obs;
in {
  options.apps.obs.enable = lib.mkEnableOption "obs";
  config = lib.mkIf cfg.enable {
    home-manager.users.${config.sys.users.default.name}.programs.obs-studio = {
      enable = true;
      package = pkgs.stable.obs-studio.override {
        cudaSupport = config.sys.graphics.nvidia.enable; # enable nvidia hardware acceleration if nvidia is enabled
      };
      plugins = with pkgs.stable.obs-studio-plugins; [
        input-overlay
        obs-pipewire-audio-capture
      ];
    };
  };
}
