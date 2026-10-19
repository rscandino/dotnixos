{moduleWithSystem, ...}: {
  flake.nixosModules.nvim = moduleWithSystem ({self', ...}: {
    programs.neovim = {
      enable = true;
      package = self'.packages.nvim;
    };
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
