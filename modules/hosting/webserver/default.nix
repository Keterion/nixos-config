{ lib, pkgs, config, ... }:
let
  cfg = config.modules.hosting.webserver;
  toml = pkgs.formats.toml {};
in {
  options.modules.hosting.webserver = {
    enable = lib.mkEnableOption "the static-web-server service";
    port = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.u16;
      default = 8787;
      description = "Port for the webserver to listen on";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.hosting.openFirewall;
      description = "Whether to allow external access to the webserver";
    };
    root = lib.mkOption {
      type = lib.types.path;
      description = "The location of files to serve. Must be set before starting the webserver";
    };
  };
  config = lib.mkIf cfg.enable {
    services.static-web-server = {
      enable = true;
      listen = "[::]:${cfg.port}";
      root = cfg.root;
      #configuration = {};
    };
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ ${cfg.port} ];
  };
}
