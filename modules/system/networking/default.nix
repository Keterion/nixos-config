{ pkgs, ... }:
{
  config = {
    networking.networkManager.enable = true;
    environment.systemPackages = with pkgs; [
      nmcli
      nmtui
    ];
  };
}
