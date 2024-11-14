{ lib, pkgs, config, ...}:
let 
  cfg = config.modules.development;

  enableLanguages = (languageList: builtins.listToAttrs (
  map
    (item: {"name" = item; "value" = true;})
    languageList
  ));
in {
  imports = [
    ./nix.nix
    ./rust.nix
  ];
  options.modules.development = {
    languages = lib.mkOption {
      description = "Languages to enable development in";
      default = ["nix"];
      example = ["nix" "rust" "typst"];
      type = lib.types.listOf (
        lib.types.enum[
	  "nix"
	  "rust"
	  "typst"
	  "bash"
	]
      );
    };
    influences = lib.mkOption {
      systemPackages.enable = lib.mkEnableOption "adding systemwide packages (compilers, dependency managers, ...)";
      editor = {
        enable = lib.mkEnableOption "adding configuration to the editors (lsp, syntax highlighting, ...)";
	lsp.enable = lib.mkOption {
	  type = lib.types.bool;
	  default = true;
	  description = "Whether to enable lsp configuration";
	};
	highlight.enable = lib.mkOption {
	  type = lib.types.bool;
	  default = true;
	  description = "Whether to enable lsp configuration";
	};
	formatting.enable = lib.mkOption {
	  type = lib.types.bool;
	  default = true;
	  description = "Whether to enable lsp configuration";
	};
      };
    };
  };
  config = {
    cfg = enableLanguages cfg.languages;
  };
}
