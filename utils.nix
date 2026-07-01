{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in {
  mkEnabledOption = name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };

  mkSimpleOption = {
    tree,
    name,
    package,
    extraConfig ? {},
    config,
  }: let
    attrsPath =
      (
        lib.splitStringBy (_: curr: builtins.elem curr ["."]) false "${tree}"
      )
      ++ ["${name}"];
    #mkConfig = (lib.getAttrFromPath attrsPath config).enable;
  in {
    options = lib.setAttrByPath attrsPath {
      enable = lib.mkEnableOption "${name}";
    };

    config = lib.mkIf config."${tree}"."${name}".enable {
      environment.systemPackages = [
        package
      ];
    };
    #// lib.mkIf mkConfig extraConfig;
  };

  # From https://codeberg.org/vaw/nixos-lib/src/branch/main/lib/firejail.nix
  # Example at https://discourse.nixos.org/t/automatic-firejail-of-home-managers-librewolf-does-not-work/22291/4
  wrapFirejailBinary = let
    script = {
      relativePath,
      firejailBinary,
      firejailArgs,
      ...
    }: ''
      (
        local prog="$out${relativePath}"
        local hidden firejail

        assertExecutable "$prog"

        hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
        while [ -e "$hidden" ]; do
          hidden="''${hidden}_"
        done
        mv "$prog" "$hidden"

        # ignore check
        assertExecutable() {
          :
        }

        firejail="${firejailBinary}\" ${firejailArgs} \"$hidden"

        makeShellWrapper "$firejail" "$prog" --inherit-argv0
      )
    '';

    wrapPhase = {
      package,
      makeWrapper,
      lib,
      ...
    } @ args: let
      ensureElem = list: elem:
        list ++ (lib.optional (!builtins.elem elem list) elem);
    in
      package.overrideAttrs (old:
        {
          nativeBuildInputs =
            ensureElem (old.nativeBuildInputs or []) makeWrapper;

          postPhases = ensureElem (old.postPhases or []) "wrapFirejailPhase";

          wrapFirejailPhase = (old.wrapFirejailPhase or "") + (script args);

          doInstallCheck =
            lib.warnIf (old.doInstallCheck or false)
            "disabeling installCheck for `${
              lib.getName package
            }` because firejail breaks it"
            false;
        }
        // (
          if (old.phases or []) != []
          then {
            phases = ensureElem old.phases "wrapFirejailPhase";
          }
          else {}
        ));

    wrapCommand = {
      package,
      makeWrapper,
      ...
    } @ args:
      package.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [makeWrapper];
        buildCommand = old.buildCommand + (script args);
      });
  in
    {
      # package to wrap an executable in
      package,
      # paths of the executables to wrap relative to package root
      relativePath ? "/bin/" + (package.meta.mainProgram or (lib.getName package)),
      # firejail profile to use (equivalent to `extraArgs = ["--profile=${profile}"]`)
      profile ? null,
      # extra arguments to pass to firejail
      extraArgs ? [],
      # path of the suid binary installed via package manager (on nixos that is '/run/wrappers/bin/firejail')
      firejailBinary ? "/run/wrappers/bin/firejail",
      pkgs ? null,
      lib ? pkgs.lib,
      makeWrapper ? pkgs.makeWrapper,
    }: let
      wrap =
        lib.throwIf ((package.buildCommandPath or "") != "")
        "wrapFirejail doesn't support derivations using `buildCommandPath`"
        (
          if (package.buildCommand or "") != ""
          then wrapCommand
          else wrapPhase
        );
    in
      wrap {
        inherit package lib makeWrapper relativePath firejailBinary;

        firejailArgs =
          lib.escapeShellArgs
          (extraArgs ++ lib.optional (profile != null) "--profile=${profile}");
      };
}
