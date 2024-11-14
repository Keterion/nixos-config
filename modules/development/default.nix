{ lib, ...}:
{
  imports = [
    ./nix.nix
    ./rust.nix
    ./typst.nix
  ];
  options.modules.development = {
    influences = {
      packageInstall.enable = lib.mkEnableOption "adding systemwide packages (compilers, dependency managers, ...)";
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
}
