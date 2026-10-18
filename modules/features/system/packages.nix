{ ... }: 
{

	flake.nixosModules.packages = { config, pkgs, ... }: {
		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		environment.systemPackages = with pkgs; [
			neovim 
				fastfetch
				tree
				wget
				git
				pciutils	
		];

	};

}






