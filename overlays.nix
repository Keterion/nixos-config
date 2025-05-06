{inputs, ...}: {
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
  #nur = final: _prev: {
  #  nur = inputs.nur.overlays.default;
  #}; # BORKED, says it wants an attrs but gets a lambda or something
}
