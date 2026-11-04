# NixOS configuration

```
modules/    single-purpose, option-gated, off by default (auto-imported)
hosts/      hardware, identity, host-specific, modules
hosts/common/      Config always applied
```

Rebuild zbook:

```bash
sudo nixos-rebuild switch --flake .#zbook
```

New host: create `hosts/<name>/` (with its `hardware-configuration.nix`), set
`myUser.name`, enable wanted modules, and add new `nixosConfiguration` entry in `flake.nix`.


Format flake code running:

```bash
nix fmt .
```

Clean rollback generations:

```bash
#clean generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d

#or
#clean all non-current generations
sudo nix-collect-garbage -d

```
