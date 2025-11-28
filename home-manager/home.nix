{ pkgs, config, lib, ... }: {
  # Sistema alvo: Lenovo Legion Go (AMD Ryzen Z1 Extreme APU - GPU integrada RDNA3).
  # Decisão: evitar hacks EGL/GLX redundantes; usar pacote vscode-fhs e nixGLMesa (quando disponível) para apps que exigem renderização.
  # Manter configuração mínima e delegar arquivos específicos aos módulos em config/.
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

  xdg = {
    enable = true;
    # Removido configFile.wezterm duplicado (já definido em wezterm.nix)
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "${pkgs.nushell}/bin/nu";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
      # Minimal session vars; GPU handled via optional nixGL + LD_LIBRARY_PATH in launcher
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.nix-profile/bin"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  # Ensure better environment handling on non-NixOS (SteamOS)
  targets.genericLinux.enable = true;

  # Help Plasma/KDE sessions pick up Nix environment without relying on shell login
  home.file.".config/plasma-workspace/env/99-nix.sh".text = ''
    #!/usr/bin/env sh
    # Source Nix profile for user
    if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
    # Ensure Nix paths are present
    export PATH="$HOME/.local/bin:$HOME/.nix-profile/bin:$PATH"
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:''${XDG_DATA_DIRS:-/usr/share}"
    # Initialize fnm (use bash output which is POSIX-compatible)
    if command -v fnm >/dev/null 2>&1; then
      eval "$(fnm env --shell=bash --use-on-cd)"
    fi
  '';

  # Refresh desktop database after package installation so KDE/SteamOS indexes .desktop files
  home.activation.refreshDesktopDB = lib.hm.dag.entryAfter ["installPackages"] ''
    if command -v xdg-desktop-menu >/dev/null 2>&1; then
      xdg-desktop-menu forceupdate || true
    fi
    if command -v update-desktop-database >/dev/null 2>&1; then
      update-desktop-database "$HOME/.nix-profile/share/applications" || true
    fi
  '';

  # Symlink Nix-provided .desktop files into ~/.local/share/applications so KDE/SteamOS discovers them
  home.activation.linkDesktopFiles = lib.hm.dag.entryAfter ["installPackages"] ''
    mkdir -p "$HOME/.local/share/applications"
    for f in "$HOME/.nix-profile/share/applications"/*.desktop; do
      [ -f "$f" ] || continue
      ln -sf "$f" "$HOME/.local/share/applications/$(basename "$f")"
    done
    if command -v update-desktop-database >/dev/null 2>&1; then
      update-desktop-database "$HOME/.local/share/applications" || true
    fi
  '';

  # Link Nerd Fonts into local fonts dir and refresh fontconfig cache
  home.activation.linkFonts = lib.hm.dag.entryAfter ["installPackages"] ''
    mkdir -p "$HOME/.local/share/fonts"
    FONT_ROOT="$HOME/.nix-profile/share/fonts"
    if [ -d "$FONT_ROOT" ]; then
      find "$FONT_ROOT" -type f \( -iname '*Caskaydia*' -o -iname '*Cascadia*' \) -print | while read -r f; do
        ln -sf "$f" "$HOME/.local/share/fonts/$(basename "$f")"
      done
    fi
    # Fallback: search wider if not found
    if [ "$(find "$HOME/.local/share/fonts" -maxdepth 1 -iname '*Caskaydia*' -o -iname '*Cascadia*' | wc -l)" -eq 0 ]; then
      find "$HOME/.nix-profile" -type f \( -iname '*Caskaydia*' -o -iname '*Cascadia*' \) -print | while read -r f; do
        ln -sf "$f" "$HOME/.local/share/fonts/$(basename "$f")"
      done
    fi
    if command -v fc-cache >/dev/null 2>&1; then
      fc-cache -f "$HOME/.local/share/fonts" || true
    fi
  '';

  # Removidos: linkEGL, run-nixgl e desktop entries customizados; confiar nos .desktop padrão.

}
