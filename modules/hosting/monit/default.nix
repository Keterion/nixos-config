{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.hosting.monit;
  storeRegex = "\/nix\/store\/.{32,}";
  fsType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Unique name for the filesystem displayed in monit";
        example = "root";
      };
      path = lib.mkOption {
        type = lib.types.path;
        description = "Path for the filesystem";
        example = "/";
      };
    };
  };
in {
  options.hosting.monit = {
    enable = lib.mkEnableOption "monit, the monitor for pretty much everything";
    port = lib.mkOption {
      type = lib.types.port;
      default = 2812;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = config.hosting.openFirewall;
    };
    fileSystems = lib.mkOption {
      type = lib.types.listOf fsType;
      default = [];
      description = "File systems to be monitored";
      example = [
        {
          name = "root";
          path = "/";
        }
        {
          name = "foo";
          path = "/mnt/foo";
        }
      ];
    };
    directories = lib.mkOption {
      type = lib.types.listOf fsType;
      default = [];
      description = "File systems to be monitored";
      example = [
        {
          name = "Movies";
          path = "/home/john/Videos";
        }
        {
          name = "Music";
          path = "/home/john/Music";
        }
      ];
    };
    monitor.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Monit doesn't need to monitor itself but the options are partly normed";
    };
    proxy.enable = lib.mkEnableOption "proxy";
  };

  config = lib.mkIf cfg.enable {
    hosting.enabledServices = ["monit"];
    environment.etc."monit/user".source = ./htpasswd;

    services.monit = {
      enable = true;
      config =
        ''
          SET DAEMON 5
          SET HTTPD PORT ${toString cfg.port}
              ALLOW md5 /etc/monit/user

        ''
        + lib.concatMapStringsSep "\n" (x: x) (map (fs: "CHECK FILESYSTEM ${fs.name} PATH ${fs.path}") cfg.fileSystems)
        + lib.concatMapStringsSep "\n" (x: x) (map (dir: "\nCHECK DIRECTORY ${dir.name} PATH ${dir.path}") cfg.directories)
        + lib.concatMapStringsSep "\n" (
          service:
            lib.optionalString
            (config.hosting."${service}".monitor.enable && config.hosting."${service}".enable)
            ''
                          
              CHECK PROCESS ${service} MATCHING "${storeRegex}.*${service}"
                restart program = "${pkgs.systemd}/bin/systemctl restart ${service}.service"''
        )
        config.hosting.enabledServices;
    };
  };
}
