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
      desktop-file-utils
      insomnia
      dconf-editor
      thunderbird
      mesa
      libglvnd
      vulkan-loader

      fnm

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
      xdg-utils
      # font runtime for GUI apps
      fontconfig
      # nerd font (Cascadia Code) via nerdfonts package
      (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; })

      # fun
      glow
      slides
      yabridge
      yabridgectl
    ]
    ++ (lib.optional (lib.hasAttr "mesa" pkgs && lib.hasAttr "drivers" pkgs.mesa) pkgs.mesa.drivers)
    # conditionally include unfree/less-common packages when available in nixpkgs
    ++ (maybe "caprine-bin")
    ++ (maybe "github-desktop")
    ++ (maybe "bitwarden-desktop")
    ++ (maybe "google-chrome")
    ++ (maybe "transmission_4-gtk")
    ++ (maybe "icon-library")
    ++ (maybe "bottles")
    ++ (maybe "webcord-vencord")
    ++ (maybe "cider");
}
