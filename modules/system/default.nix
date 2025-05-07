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
    ./graphics
    ./hid
    ./lockscreen
    ./networking
    ./runner
    ./security
    ./shell
    ./terminal
    #    ./tools
    ./wm
    ./printing
  ];

  config = {
    networking.networkmanager.enable = true;
    hardware.graphics.enable = true;

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowHybridSleep=yes
      AllowSuspendThenHibernate=yes
    '';
  };
}
