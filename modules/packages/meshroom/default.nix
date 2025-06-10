{pkgs, ...}: {
  config = {
    nixpkgs.overlays = [
      (_final: _prev: {
        meshroom = pkgs.callPackage ./meshroom.nix {};
      })
    ];
  };
}
