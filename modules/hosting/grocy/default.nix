{ lib, config, ... }: 
let
  cfg = config.modules.services.grocy;
in {
  options.modules.services.grocy = {
    enable = lib.mkEnableOption " grocy";
  };

  config = lib.mkIf cfg.enable {
    services.grocy = {
      enable = true;
      settings = {
	culture = "en";
	currency = "EUR";
	calendar.firstDayOfWeek = 1;
      };
    };
  };
}
