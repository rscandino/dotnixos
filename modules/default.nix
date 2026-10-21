# Every module is always imported; each one only does something when its
# `my.<feature>.enable` option is true (set per host).
{
  imports = [
    ./dev.nix
    ./dotfiles.nix
    ./desktop.nix
    ./niri.nix
    ./gaming.nix
  ];
}
