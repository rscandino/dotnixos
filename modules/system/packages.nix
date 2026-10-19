{ ... }: 
{

	flake.nixosModules.packages = { config, pkgs, ... }: {
		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		environment.systemPackages = with pkgs; [
				fastfetch
				vim
				tree
				wget
				git
				pciutils	
		];

	};

}






