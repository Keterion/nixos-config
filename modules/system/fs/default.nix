{ config, ... }: {
  config = {
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      polkit.enable = true;
    };
  };
}
