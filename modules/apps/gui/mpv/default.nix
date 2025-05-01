{ lib, pkgs, config, ... }:
let
  cfg = config.apps.mpv;
in {
  options.apps.mpv = {
    enable = lib.mkOption {
      default = config.apps.modules.gui.all.enable;
      type = lib.types.bool;
      description = "Whether to enable mpv.";
    };    #image-support.enable = lib.mkEnableOption "image display support for mpv";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mpv ];

    home-manager.users.${config.system.users.default.name}.programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
	thumbfast
	mpv-notify-send
	mpris

	uosc
      ]; #++ lib.optionals cfg.image-support.enable [
	#mpv-image-viewer.image-positioning
#	mpv-image-viewer.detect-image
      #];
      config = {
	autofit-larger = "100%x100%";
	hwdec="yes";
	keep-open="yes";
      };
      #scriptOpts = {
#	detect_image = {
#	  "command_on_image_loaded" = "enable-section enable-section";
#	};
      #};
    };
  };
}
