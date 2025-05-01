{ lib, pkgs, config, ... }:
let cfg = config.modules.services.qbittorrent;
in {
  options = {
    services.qbittorrent = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Run qBittorrent headlessly as systemwide daemon
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/qbittorrent";
        description = ''
          The directory where qBittorrent will create files.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "qbittorrent";
        description = ''
          User account under which qBittorrent runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "qbittorrent";
        description = ''
          Group under which qBittorrent runs.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = ''
          qBittorrent web UI port.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open services.qBittorrent.port to the outside network.
        '';
      };

      openFilesLimit = lib.mkOption {
        default = 4096;
        description = ''
          Number of files to allow qBittorrent to open.
        '';
      };
    };
    modules.services.qbittorrent = {
      enable = lib.mkEnableOption "qbittorrent";
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = config.modules.hosting.openFirewall;
        description = "the firewall rule for qbittorrent";
      };
      port = lib.mkOption {
        type = lib.types.ints.u32;
        default = 8080;
        description = "Port to use for the radicale server";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qbittorrent ];

    nixpkgs.overlays = [
      (final: prev: {
        qbittorrent = prev.qbittorrent.override { guiSupport = false; };
      })
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.qbittorrent = {
      after = [ "network.target" ];
      description = "qBittorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.qbittorrent ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.qbittorrent}/bin/qbittorrent-nox \
            --profile=${config.services.qbittorrent.dataDir}/.config \
            --webui-port=${toString cfg.port}
        '';
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        Restart = "on-success";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        LimitNOFILE = cfg.openFilesLimit;
      };
    };

    users.users = lib.mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
        description = "qBittorrent Daemon user";
      };
    };

    users.groups =
      lib.mkIf (cfg.group == "qbittorrent") { qbittorrent = { gid = null; }; };

    services.qbittorrent = {
      enable = true;
      group = lib.mkIf config.modules.hosting.commonGroup.enable config.modules.hosting.commonGroup.name;
      openFirewall = lib.mkDefault cfg.openFirewall;
      user = "qbittorrent";

      port = cfg.port;
    };
  };
}
