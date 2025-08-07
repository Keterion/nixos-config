{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;

    age.keyFile = "/home/${config.system.users.default.name}/.config/sops/age/keys.txt";

    secrets = {
      "syncthing/SM_A715F" = {};
    };
  };
}
