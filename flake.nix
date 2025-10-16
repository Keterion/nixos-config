{
  description = "New NixOS Config ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millenium = {
      #steam theming
      url = "git+https://github.com/SteamClientHomebrew/Millennium";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    custom_overlays = import ./overlays.nix {inherit inputs;};
    overlays = [
      inputs.nur.overlays.default
      custom_overlays.stable-packages
      inputs.millenium.overlays.default
    ];
  in {
    nixosConfigurations = {
      main = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          myUtils = import ./utils.nix {inherit inputs;};
          inherit inputs;
        };
        modules = [
          {nixpkgs.overlays = overlays;}
          ./machines/common.nix
          ./machines/main

          inputs.nvf.nixosModules.default

          home-manager.nixosModules.home-manager
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          myUtils = import ./utils.nix {inherit inputs;};
          inherit inputs;
        };
        modules = [
          {nixpkgs.overlays = overlays;}
          ./machines/common.nix
          ./machines/laptop

          inputs.nvf.nixosModules.default

          home-manager.nixosModules.home-manager
        ];
      };
      Hypnos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          myUtils = import ./utils.nix {inherit inputs;};
          inherit inputs;
        };
        modules = [
          {nixpkgs.overlays = [inputs.nur.overlays.default overlays.stable-packages];}
          ./machines/common.nix
          ./machines/hypnos

          inputs.nvf.nixosModules.default

          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
