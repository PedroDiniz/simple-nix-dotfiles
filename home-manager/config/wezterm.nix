{ pkgs, ... }:
let
  wezWrapped = pkgs.writeShellScriptBin "wezterm" ''
    # Minimal SteamOS/KDE-friendly env: use host GL paths, force X11 + Software
    export LIBGL_DRIVERS_PATH="/usr/lib/dri:${pkgs.mesa.drivers}/lib/dri:''${LIBGL_DRIVERS_PATH:-}"
    export __EGL_VENDOR_LIBRARY_DIRS="/usr/share/glvnd/egl_vendor.d:${pkgs.libglvnd}/share/glvnd/egl_vendor.d:''${__EGL_VENDOR_LIBRARY_DIRS:-}"
    export LD_LIBRARY_PATH="$HOME/.nix-profile/lib:/usr/lib:''${LD_LIBRARY_PATH:-}"
    export WINIT_UNIX_BACKEND="x11"
    export WEZTERM_FRONTEND="Software"
    exec "${pkgs.wezterm}/bin/wezterm" "$@"
  '';
  xterm = pkgs.writeShellScriptBin "xterm" ''${wezWrapped}/bin/wezterm "$@"'';
  kgx = pkgs.writeShellScriptBin "kgx" ''${wezWrapped}/bin/wezterm "$@"'';
in {
  home.packages = [ wezWrapped xterm kgx ];
  xdg.configFile.wezterm.source = ../../wezterm;
}
