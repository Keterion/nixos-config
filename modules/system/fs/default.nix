{ ... }: {
  config = {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
    };
    security.polkit.enable = true;
  };
}
