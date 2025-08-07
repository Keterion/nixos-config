{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFile = false;

    age.keyFile = "/home/${config.system.users.default.name}/.config/sops/age/keys.txt";

    secrets = {
      "syncthing/SM-A715F" = {};
    };
  };
}
