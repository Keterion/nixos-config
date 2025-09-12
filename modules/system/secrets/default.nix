{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = {
    environment.systemPackages = with pkgs; [
      sops
    ];
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;

      age.keyFile = "/home/${config.system.users.default.name}/.config/sops/age/keys.txt";

      secrets = {
        "private_keys/etherion" = {
          path = "/home/etherion/.ssh/id_ed25519";
        };
      };
    };
  };
}
