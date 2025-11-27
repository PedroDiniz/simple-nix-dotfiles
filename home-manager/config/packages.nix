{pkgs, ...}: {
  imports = [
    ../scripts/blocks.nix
    ../scripts/nx-switch.nix
    ../scripts/vault.nix
  ];

  xdg.desktopEntries = {
    "lf" = {
      name = "lf";
      noDisplay = true;
    };
  };

  home.packages = let
    lib = pkgs.lib;
    getPkg = attr: if lib.hasAttr attr pkgs then lib.getAttr attr pkgs else null;
    maybe = attr: let p = getPkg attr; in lib.optional (p != null) p;
  in with pkgs;
    [
      # gui
      obsidian
      (mpv.override { scripts = [ mpvScripts.mpris ]; })
      libreoffice
      gimp
      dconf
      xdg-utils
      desktop-file-utils
      insomnia
      dconf-editor
      thunderbird

      # langs / runtimes
      poetry
      fnm

      # tools
      bat
      eza
      fd
      ripgrep
      fzf
      libnotify
      killall
      zip
      unzip
      glib
      mongodb-compass
      gh
      rclone
      # graphics/runtime libs for GUI apps (wezterm EGL issue)
      mesa
      libglvnd
      vulkan-loader
      wayland
      libxkbcommon
      fontconfig
      # nerd font (Cascadia Code) via nerdfonts package
      (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; })

      # fun
      glow
      slides
      yabridge
      yabridgectl
    ]
    # conditionally include unfree/less-common packages when available in nixpkgs
    ++ (maybe "caprine-bin")
    ++ (maybe "github-desktop")
    ++ (maybe "bitwarden-desktop")
    ++ (maybe "google-chrome")
    ++ (maybe "transmission_4-gtk")
    ++ (maybe "icon-library")
    ++ (maybe "r2modman")
    ++ (maybe "bottles")
    ++ (maybe "webcord-vencord")
    ++ (maybe "cider");
}
