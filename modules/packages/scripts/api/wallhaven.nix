{
  lib,
  pkgs,
  config,
  ...
}: {
  options.scripts.api.wallhaven.enable = lib.mkEnableOption "wallhaven api requests";

  config = lib.mkIf config.scripts.api.wallhaven.enable {
    sops.secrets."wallhaven/api_key" = {};
    sops.templates."wallhaven_api".content = ''${config.sops.placeholder."wallhaven/api_key"}$'';

    environment.systemPackages = lib.optionals config.scripts.api.wallhaven.enable [
      (pkgs.writeShellScriptBin "top_wallpaper" ''
        curl "https://wallhaven.cc/api/v1/search?categories=111&purity=100&atleast=1920x1080&ratios=16x9,16x10&sorting=toplist&topRange=1w&apikey=$(cat ${config.sops.templates."wallhaven_api".path})" | ${pkgs.jq}/bin/jq '.["data"][0]["path"]' | xargs curl -A "X-API-KEY: $(cat ${config.sops.templates."wallhaven_api".path})$" -o /home/${config.system.users.default.name}/Pictures/wallhaven.png
      '')
    ];
  };
}
