{ pkgs, lib, config, ...}: 
with lib;
let
  cfg = config.modules.apps.git;
in
{
  options.modules.apps.git = {
    enable = mkEnableOption "the git version control";
    defaultBranch = mkOption {
      type = types.str;
      default = "main";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = cfg.enable;
      config = {
	init.defaultBranch = cfg.defaultBranch;
      };
    };
  };
}
