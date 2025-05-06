{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.rustypaste;
  configDir = "/rustypaste";
  toml = pkgs.formats.toml {};
in {
  options.services.rustypaste = {
    enable = lib.mkEnableOption "rustypaste";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/rustypaste";
      description = ''
        The directory where rustypaste will create files.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "rustypaste";
      description = ''
        User account under which rustypaste runs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "rustypaste";
      description = ''
        Group under which rustypaste runs.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        rustypaste web UI port.
      '';
    };

    ip = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        rustypaste ip address
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open services.rustypaste.port to the outside network.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustypaste
    ];

    environment.etc."${configDir}/config.toml" = {
      #user = "${cfg.user}";
      #group = "${cfg.group}";
      #mode = "0644";
      source = toml.generate "config" {
        config.refresh_rate = "1s";
        server = {
          address = "${cfg.ip}:${toString cfg.port}";
          max_content_length = "10MB";
          upload_path = "./upload";
          timeout = "30s";
          expose_version = false;
          expose_list = false;

          handle_spaces = "replace";
        };
        landing_page = {
          text = ''
            ┬─┐┬ ┬┌─┐┌┬┐┬ ┬┌─┐┌─┐┌─┐┌┬┐┌─┐
            ├┬┘│ │└─┐ │ └┬┘├─┘├─┤└─┐ │ ├┤
            ┴└─└─┘└─┘ ┴  ┴ ┴  ┴ ┴└─┘ ┴ └─┘

            Submit files via HTTP POST here:
                curl -F 'file=@example.txt' <server>
            This will return the URL of the uploaded file.

            The server administrator might remove any pastes that they do not personally
            want to host.

            If you are the server administrator and want to change this page, just go
            into your config file and change it! If you change the expiry time, it is
            recommended that you do.

            By default, pastes expire every hour. The server admin may or may not have
            changed this.

            Check out the GitHub repository at https://github.com/orhun/rustypaste
            Command line tool is available  at https://github.com/orhun/rustypaste-cli
          '';
          content_type = "text/plain; charset=utf-8";
        };
        paste = {
          #random_url = {
          #  type = "petname";
          #  words = 2;
          #  separator = "-";
          #};
          random_url = {
            type = "alphanumeric";
            length = 8;
          };
          default_extension = "txt";
          duplicate_files = true;
          delete_expired_files = {
            enabled = true;
            interval = "1h";
          };
          mime_override = [
            {
              mime = "image/jpeg";
              regex = "^.*\\.jpg$";
            }
            {
              mime = "image/png";
              regex = "^.*\\.png$";
            }
            {
              mime = "image/svg+xml";
              regex = "^.*\\.svg$";
            }
            {
              mime = "video/webm";
              regex = "^.*\\.webm$";
            }
            {
              mime = "video/x-matroska";
              regex = "^.*\\.mkv$";
            }
            {
              mime = "application/octet-stream";
              regex = "^.*\\.bin$";
            }
            {
              mime = "text/plain";
              regex = "^.*\\.(log|txt|diff|sh|rs|toml)$";
            }
          ];
          mime_blacklist = [
            "application/x-dosexec"
            "application/java-archive"
            "application/java-vm"
          ];
        };
      };
    };

    systemd.services.rustypaste = {
      after = ["network.target"];
      description = "Rustypaste daemon";
      wantedBy = ["multi-user.target"];
      path = [pkgs.rustypaste];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.rustypaste}/bin/rustypaste
        '';
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        WorkingDirectory = "${cfg.dataDir}";
        Restart = "on-success";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
      };
      environment = {
        CONFIG = "/etc/${configDir}/config.toml";
      };
    };
    users.users = lib.mkIf (cfg.user == "rustypaste") {
      rustypaste = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
        description = "Rustypaste Daemon user";
        isSystemUser = true;
      };
    };

    users.groups =
      lib.mkIf (cfg.group == "rustypaste") {rustypaste = {gid = null;};};

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
