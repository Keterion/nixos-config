{
  lib,
  config,
  ...
}: let
  cfg = config.sys.groups;
in {
  config = {
    users.groups.server = {
      gid = 990;
      name = "server";
    };
  };
}
