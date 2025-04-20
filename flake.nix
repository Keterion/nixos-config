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

    nur.url = "github:nix-community/nur";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let 
      overlays = import ./overlays.nix { inherit inputs; };
    in {
      nixosConfigurations = {
	main = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  specialArgs = { myUtils = import ./utils.nix { inherit inputs; }; };
	  modules = [
	    { nixpkgs.overlays = [ overlays.nur overlays.stable-packages ]; }
	    ./machines/common.nix
	    ./machines/main
	    
	    home-manager.nixosModules.home-manager
	  ];
	};
      };
    };
  }

