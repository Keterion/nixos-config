{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.system.graphics;
in {
  options.system.graphics = {
    nvidia.enable = lib.mkEnableOption "nvidia configuration to work";
  };

  config = {
    services.xserver.videoDrivers = lib.optionals cfg.nvidia.enable ["nvidia"];
    boot.kernelParams = lib.optionals cfg.nvidia.enable ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    hardware.nvidia = lib.mkIf cfg.nvidia.enable {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      package = pkgs.linuxPackages.nvidiaPackages.beta;
    };
    hardware.graphics.extraPackages = lib.optionals cfg.nvidia.enable [pkgs.nvidia-vaapi-driver];
  };
}
