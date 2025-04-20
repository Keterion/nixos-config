{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  system.audio.pipewire = {
    enable = true;
    rtkit.enable = true;
    compatibility.pulse.enable = true;
    compatibility.jack.enable = true;
  };
  system.firewall = {
    enable = true;
  };
  system.fonts = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.heavy-data
    nerd-fonts.jetbrains-mono
  ];
  system.keyboard = {
    layout = "us";
    variant = "";
  };
  system.users.default = {
    name = "etherion";
  };

  fileSystems."/mnt/Games" = {
    device = "dev/disk/by-uuid/3212add8-8af3-46c6-a739-cfc018bd72ac";
    fsType = "ext4";
  };

  boot.initrd.luks.devices.HDD.device = "/dev/disk/by-uuid/0161cbc2-6ac8-42b4-874e-74c95c494aa9";
  fileSystems."/mnt/HDD" = {
    device = "/dev/mapper/HDD";
  };

  boot.initrd.luks.devices.Priv.device = "/dev/disk/by-uuid/ef533879-a0c5-456a-8a91-db761e21ed63";
  fileSystems."/mnt/priv" = {
    label = "Priv";
    device = "/dev/mapper/Priv";
  };
}
