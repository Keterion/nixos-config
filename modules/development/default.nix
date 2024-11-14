{ lib, config, ...}:
let
  cfg = config.modules.development;
in {
  imports = [
    ./nix.nix
    ./rust.nix
    ./typst.nix
  ];
  options.modules.development = {
    influences = {
      packageInstall = lib.mkEnableOption "adding systemwide packages (compilers, dependency managers, ...)";
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
	autocomplete.enable = lib.mkOption {
	  type = lib.types.bool;
	  default = true;
	  description = "Whether to enable lsp configuration";
	};
      };
    };
  };
  config = {
    warnings = (
      lib.optionals (cfg.influences.editor.lsp.enable && !cfg.influences.packageInstall) "Can't install lsp without enabling modules.development.influences.packageInstall"
    );
  }; 
}
