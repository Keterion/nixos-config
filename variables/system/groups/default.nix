{ lib, config, ... }:
let
  cfg = config.system.groups;
in {
  config = {
    users.groups.server = {
      gid = 990;
      name = "server";
    };
  };
}
