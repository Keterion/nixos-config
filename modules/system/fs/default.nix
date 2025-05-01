{ pkgs, ... }: {
  config = {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
    };
    security.polkit.enable = true;

    environment.systemPackages = [
      pkgs.encfs
    ];
  };
}
