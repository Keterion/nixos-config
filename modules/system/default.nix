{pkgs, ...}: {
  imports = [
    ./audio
    ./bar
    ./bluetooth
    ./de
    ./dm
    ./firewall
    ./fonts
    ./fs
    ./hid
    ./lockscreen
    ./runner
    ./security
    ./shell
    ./terminal
    #    ./tools
    ./wm
    ./printing
  ];

  config = {
    boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      package = pkgs.linuxPackages.nvidiaPackages.beta;
    };
    hardware.graphics.enable = true;

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };
}
