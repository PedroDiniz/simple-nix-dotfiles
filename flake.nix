{
  description = "Configurations of Kaldr";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: {
    # nixos hm config
    homeConfigurations = let
      username = "deck";
    in {
      "${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
            overlays = [ stableWeztermOverlay ];
          };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home-manager/home.nix
          ({ pkgs, ... }: {
            nix.package = pkgs.nix;
            home = {
              username = username;
              homeDirectory = "/home/${username}";
            };
          })
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
