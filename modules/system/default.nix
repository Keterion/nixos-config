{...}: {
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
    ./mimetypes
    ./networking
    ./notifications
    ./runner
    ./secrets
    ./security
    ./shell
    ./ssh
    ./terminal
    #    ./tools
    ./wm
    ./printing
  ];

  config = {
    hardware.graphics.enable = true;

    #systemd.sleep.settings.Sleep = ''
    #  AllowSuspend=yes
    #  AllowHibernation=yes
    #  AllowHybridSleep=yes
    #  AllowSuspendThenHibernate=yes
    #'';
  };
}
