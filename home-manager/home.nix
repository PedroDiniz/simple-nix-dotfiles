{config, ...}: {
  imports = [
    ./config/nvim.nix
    ./config/blackbox.nix
    ./config/distrobox.nix
    ./config/git.nix
    ./config/lf.nix
    ./config/neofetch.nix
    ./config/packages.nix
    ./config/sh.nix
    ./config/starship.nix
    ./config/tmux.nix
    ./config/wezterm.nix
    ./config/vscode.nix
  ];

  news.display = "show";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    warn-dirty = false;
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "21.11";
}
