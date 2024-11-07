{ lib, config, ...}: 
let
  cfg = config.system.shell.prompt.starship;
in {
  imports = [
    ./starship.nix
  ];
  options.system.shell.prompt.starship = {
    enable = lib.mkEnableOption "the starship prompt";
  };
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
	add_newline = true;
      };
    };
  };
}
