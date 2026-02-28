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

  outputs =
    { ... }@inputs:
    let
      # helper to create host config
      mkHost =
        {
          hostname,
          rootUUID,
          bootUUID,
          swapUUID,
          sysType ? "x86_64-linux",
        }:
        inputs.nixpkgs.lib.nixosSystem {
          system = sysType;

          specialArgs = { inherit hostname rootUUID bootUUID swapUUID; };

          modules = [
            inputs.catppuccin.nixosModules.catppuccin
            
            # base config for all hosts
            ./hosts/base/configuration.nix
            ./hosts/base/hardware-configuration.nix

            # device specific config
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

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
                extraSpecialArgs = { inherit inputs hostname; };
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
          rootUUID = "6578503f-8659-477b-8606-3b731bfee722";
          bootUUID = "AA06-D565";
          swapUUID = "a33bb431-ec32-414e-b61a-80badd6b49a2";
        };

        # laptop config
        EvBook = mkHost {
          hostname = "EvBook";
          rootUUID = "f06398c5-3ca4-4043-b351-bca06b399fda";
          bootUUID = "5F66-17ED";
          swapUUID = "43fd4f58-63ba-49f9-94a7-93542e8dbab7";
        };
      };
    };
}
