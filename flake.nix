{
  description = "My (hopefully not too bad) NixOS Flake"; # Thank you Creator34 & prolly many others :)

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    catppuccin.url = "github:catppuccin/nix?ref=v25.05";
  };

  outputs = {...}@inputs:
  let
    # helper to create host config
    mkHost = {
      hostname,
      configFile,
      sysType ? "x86_64-linux"
    }:
    inputs.nixpkgs.lib.nixosSystem {
      system = sysType;

      modules = [
        # device specific config
        configFile

        # set up alacritty theme
        (_: {
          nixpkgs.overlays = [ inputs.alacritty-theme.overlays.default ];
        })

        # config home-manager
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; hostname; };
            users.evren = import ./home-manager/home.nix;
          };
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      # desktop config [ see what i did ;) ]
      EvTop = mkHost {
        hostname = "EvTop";
        configFile = ./hosts/evtop/configuration.nix;
      };

      # laptop config
      EvBook = mkHost {
        hostname = "EvBook";
        configFile = ./hosts/evbook/configuration.nix;
      };
    };
  };
}
