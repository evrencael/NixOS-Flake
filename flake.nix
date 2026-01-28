{
  description = "A not that basic flake"; # Thank you Creator34

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    catppuccin.url = "github:catppuccin/nix?ref=v25.05";
  };

  outputs = {...}@inputs: {
    nixosConfigurations = {
      evren = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	      modules = [
	        ./configuration.nix

          (_: {
            nixpkgs.overlays = [ inputs.alacritty-theme.overlays.default ];
          })

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.evren = import ./home-manager/home.nix;
            };
          }
        ];
      };

      evbook = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	      modules = [
	        ./configuration-evbook.nix

          (_: {
            nixpkgs.overlays = [ inputs.alacritty-theme.overlays.default ];
          })

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.evren = import ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  };
}
