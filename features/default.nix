# Every module is always imported; each one only does something when its
# `my.<feature>.enable` option is true (set per host).
{
  imports = [
    ./desktop.nix
    ./dotfiles.nix
    ./gaming.nix
    ./niri.nix
  ];
}
