{inputs, moduleWithSystem, ...}: {
  inputs.self.nixosModules.nvim = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.nvim];
    environment.variables.EDITOR = "nvim";
	environment.shellAliases = {
	  vi = "nvim";
	  vim = "nvim";
	};
  });

  perSystem = {inputs', ...}: {
    packages.nvim = inputs'.nvim.packages.default;
  };
}
