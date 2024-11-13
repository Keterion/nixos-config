{lib, config, ...}: {
  options.modules.privacy.hosts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable host file based blocking";
      default = true;
      example = false;
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.enum["fakenews" "gambling" "porn" "social"];
      description = "Additional sites to block";
      default = [];
    };
  };

  config = lib.mkIf config.modules.privacy.hosts.enable {
    networking.stevenblack = {
      enable = true;
      block = config.modules.privacy.hosts.extensions;
    };
  };
}
