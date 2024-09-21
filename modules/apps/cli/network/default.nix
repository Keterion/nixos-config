{ config, pkgs, lib, ... }:
let
  cfg = config.modules.apps.cli;
  pkgs_to_install = with pkgs; [
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc
    iftop
  ];
in
{
  imports = [
  ]
  
  options.modules.apps.cli.network = {
    enable = lib.mkEnableOption "network tools";
    root = lib.mkEnableOption "install the tools for the root user";
  };

  config = lib.mkIf cfg.network.enable {
    system.environmentPackages = lib.mkIf cfg.network.root pkgs_to_install;
    home-manager.users."etherion" = {
      home.packages = pkgs_to_install;
    };
  };
}
