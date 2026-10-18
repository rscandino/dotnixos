{ self, inputs, ... }: {
  flake.nixosConfigurations.zbook = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      zbookConfiguration
      zbookHardware
      system
    ];
  };
}

