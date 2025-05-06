{ pkgs, ... }:
{
  config = {
    networking.networkmanager.enable = true;
    environment.systemPackages = with pkgs; [
      networkmanager
      iwifi
    ];
  };
}
