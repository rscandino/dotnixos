# Auto-imports every .nix file below this directory (except default.nix files).
# Adding a module = dropping a file in. Every module is off by default.
{lib, ...}: {
  imports =
    lib.filter
    (p: lib.hasSuffix ".nix" (toString p) && baseNameOf p != "default.nix")
    (lib.filesystem.listFilesRecursive ./.);
}
