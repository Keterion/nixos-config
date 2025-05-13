{pkgs, ...}: {
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        tandoor-recipes = prev.tandoor-recipes.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "TandoorRecipes";
            repo = "recipes";
            rev = "11678431e18c19e929d7f08d156f0ddd3fd7f6fe"; # 2.0.0-alpha-3
            hash = "sha256-VHf0zYQJ2b8Iemfu0fMK5tQ1guvguVTtHQFRwF40vQM";
          };
          buildInputs = with pkgs.python312Packages;
            old.buildInputs
            ++ [
              drf-spectacular
              drf-spectacular-sidecar
              django-vite
              litellm
            ];
        });
      })
    ];
  };
}
