{
  description = "New NixOS Config ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #sops-nix = {
    #  url = "github:Mic92/sops-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    overlays = import ./overlays.nix {inherit inputs;};
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {myUtils = import ./utils.nix {inherit inputs;};};
        modules = [
          {nixpkgs.overlays = [inputs.nur.overlays.default overlays.stable-packages];}
          ./machines/common.nix
          ./machines/main

          inputs.nvf.nixosModules.default

          home-manager.nixosModules.home-manager
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = {myUtils = import ./utils.nix {inherit inputs;};};
	modules = [
	  {nixpkgs.overlays = [inputs.nur.overlays.default overlays.stable-packages];}
	  ./machines/common.nix
	  ./machines/laptop

	  inputs.nvf.nixosModules.default

	  home-manager.nixosModules.home-manager
	];
      };
    };
  };
}
