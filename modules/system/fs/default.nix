{pkgs, ...}: {
  config = {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
    };
    security.polkit.enable = true;

    environment.systemPackages = [
      pkgs.encfs
    ];

    #swapDevices = [ # swap hibernate doesn't work its broken somehow
    #  {
    #    device = "/var/lib/hibernate";
    #    size = 1024 * 32; # 32GB of swap for hibernate, TODO
    #    priority = 0; # Lowest priority so hopefully never used, also kernel params make sure of that
    #  }
    #];
    #boot.kernel.sysctl = {
    #  "vm.swappiness" = 0; # disable swap partition usage to allow hibernate to swap
    #};
  };
}
