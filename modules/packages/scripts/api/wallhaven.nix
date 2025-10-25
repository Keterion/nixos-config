{
  lib,
  pkgs,
  config,
  ...
}: {
  options.scripts.api.wallhaven.enable = lib.mkEnableOption "wallhaven api requests";

  config = lib.mkIf config.scripts.api.wallhaven.enable {
    sops.secrets."wallhaven/api_key" = {
      owner = "${config.system.users.default.name}";
    };
    sops.templates."wallhaven_api" = {
      owner = "${config.system.users.default.name}";
      content = ''${config.sops.placeholder."wallhaven/api_key"}'';
    };

    environment.systemPackages = lib.optionals config.scripts.api.wallhaven.enable [
      (pkgs.writeShellScriptBin "top_wallpaper" ''
        api_key=$(cat ${config.sops.templates."wallhaven_api".path})
        curl "https://wallhaven.cc/api/v1/search?categories=111&purity=100&atleast=1920x1080&ratios=16x9,16x10&sorting=toplist&topRange=1w&apikey=$api_key" \
            | ${pkgs.jq}/bin/jq '.["data"][0]["path"]' \
            | xargs curl -A "X-API-KEY: $api_key" -o /home/${config.system.users.default.name}/Pictures/wallhaven.png
      '')
    ];
  };
}
