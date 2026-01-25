{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  cfg = config.sys.sops;
in {
  options.sys.sops = {
    age.keyFile = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.sys.users.default.name}/.config/sops/age/keys.txt";
      description = "Keyfile path";
    };
  };
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = {
    environment.systemPackages = with pkgs; [
      sops
    ];
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;

      age.keyFile = cfg.age.keyFile;

      secrets = {
        #"private_keys/etherion" = {
        #  path = "/home/etherion/.ssh/id_ed25519";
        #  owner = "etherion";
        #  mode = "0644";
        #};
      };
    };
  };
}
