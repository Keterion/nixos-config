{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, nixpkgs-stable, arkenfox, spicetify-nix, ... }@inputs: 
  let
    overlays = import ./overlays.nix {inherit inputs;};
  in
  {
  # TODO:
  # Hosted services bookmarks -> global main user because firefox is homemanager not global
  # Hosted services webserver automatic
  # Programming language toggle -> nixvim lsp installation and stuff
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  { nixpkgs.overlays = [ nur.overlay overlays.stable-packages ]; }
	  ./hosts/common.nix
	  ./hosts/laptop/default.nix

	  home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = { inherit inputs; };
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

	    home-manager.backupFileExtension = "bak";

	    home-manager.users.etherion = import ./hosts/laptop/home.nix;
	  }
	];
      };
      main = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  { nixpkgs.overlays = [ nur.overlay overlays.stable-packages ]; }
	  ./hosts/common.nix
	  ./hosts/main/default.nix
	  
	  home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = { inherit inputs; };
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

	    home-manager.backupFileExtension = "bak";

	    home-manager.users.etherion = import ./hosts/main/home.nix;
	  }
	];
      };
    };
  };
}
