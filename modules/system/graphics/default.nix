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
    intel = {
      enable = lib.mkEnableOption "intel configuration to work";
      old.enable = lib.mkEnableOption "support for older intel graphics";
    };
  };

  config = {
    services.xserver.videoDrivers = lib.optionals cfg.nvidia.enable ["nvidia"] ++ lib.optionals (cfg.intel.enable && cfg.intel.old.enable) ["intel"] ++ lib.optionals (cfg.intel.enable && !cfg.intel.old.enable) ["modesetting"];
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
