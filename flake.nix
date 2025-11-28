{
  description = "Configurations of Kaldr";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    ...
  }: let
    # Overlay: force wezterm to a known stable release tag instead of unstable build
    # Overlay: attempt to use a stable tagged release of wezterm.
    # NOTE: cargoHash/sha256 placeholders will need updating after first build error.
    stableWeztermOverlay = (final: prev: {
      wezterm = prev.wezterm.overrideAttrs (old: rec {
        version = "20240203-110809-5046fc22";
        src = prev.fetchFromGitHub {
          owner = "wez";
          repo = "wezterm";
          rev = version;
          sha256 = "sha256-hhuzs89wWKc7n6HMKriWvV+pLhfLvO06XRWtmdCQ0rs="; # updated real src hash
        };
        cargoHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB="; # placeholder; will be reported by Nix
        dontStrip = true;
      });
    });
  in {
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
