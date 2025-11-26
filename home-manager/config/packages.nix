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

  home.packages = with pkgs;
  with gnome; [
    # gui
    obsidian
    (mpv.override {scripts = [mpvScripts.mpris];})
    libreoffice
    caprine-bin
    d-spy
    github-desktop
    gimp
    transmission_4-gtk
    insomnia
    icon-library
    dconf-editor
    thunderbird
    bitwarden-desktop
    fnm

    # langs
    poetry
    nodejs
    yarn
    go

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
    google-chrome
    rclone

    # gaming
    r2modman
    mangohud
    goverlay
    bottles
    protonup-qt
    chiaki
    gamescope
    gamemode
    lutris
    winetricks
    wine-staging
    webcord-vencord

    # fun
    glow
    slides
    yabridge
    yabridgectl
    cider
  ];
}
