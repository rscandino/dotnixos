{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.dev;
in {
  options.modules.dev.enable = lib.mkEnableOption "development tools";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.tmux = {
      enable = true;
      clock24 = true;
    };

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      distrobox
      git
      jujutsu
      ripgrep
      fd
      jq
      gcc
      gnumake
      tree-sitter
      nil
      alejandra
      lua-language-server
      stylua
      ast-grep
    ];
  };
}
