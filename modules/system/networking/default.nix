{ pkgs, ... }:
{
  config = {
    neworking.networkManager.enable = true;
    environment.systemPackages = with pkgs; [
      nmcli
      nmtui
    ];
  };
}
