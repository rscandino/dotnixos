{
  description = "NixOS config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Lockscreen for wayland compositors
    veila = {
      url = "github:naurissteins/Veila";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mangowm
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    veila,
    mangowm,
    ...
  }: {
    nixosConfigurations.zbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/zbook
        ./modules
        ./features

        veila.nixosModules.default
        {
          programs.veila = {
            enable = true;
            service.enable = true;
            idle = {
              enable = true;
              lockAfter = 300;
              lockBeforeSleep = true;
            };
          };
        }

        mangowm.nixosModules.mango
        {
          programs.mango.enable = true;
        }

      ];
    };
  };
}
