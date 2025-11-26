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
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          asztal = self.packages.x86_64-linux.default;
        };
        modules = [
          ./nixos/home.nix
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
