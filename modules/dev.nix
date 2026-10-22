{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modDev;
in {
  options.modDev.enable = lib.mkEnableOption "Development tools" // {default = false;};

  config = lib.mkIf cfg.enable {

    # NEOVIM install; the config (~/.config/nvim) must be defined (or stowed).
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # DIRENV, when in devShel automatic enabling through .envrc
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # TMUX setup
    programs.tmux = {
      enable = true;
      clock24 = true;
    };

    # PODMAN enable virtualisation
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # System packages
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
      git
      jujutsu
      ripgrep
      fd
      jq
      gcc
      gnumake
      wl-clipboard
      tree-sitter
      nil
      alejandra
      lua-language-server
      stylua
      ast-grep
    ];
  };
}
