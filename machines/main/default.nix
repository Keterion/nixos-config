{ pkgs, ... }: {
  imports = [./hardware-configuration.nix];
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
}
