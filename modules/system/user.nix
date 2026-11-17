{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.user;
in {
  options.modules.system.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Primary user name for this host (must be set by every host)";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["wheel" "networkmanager" "video"];
      description = "Primary user extraGroups for this host";
    };

    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
      description = "Primary user default shell for this host";
    };

    initialPassword = lib.mkOption {
      type = lib.types.str;
      default = "passpass";
      description = "Primary user initial password for this host";
    };
  };

  config.users.users.${cfg.name} = {
    isNormalUser = true;
    inherit (cfg) extraGroups shell initialPassword;
  };
}
