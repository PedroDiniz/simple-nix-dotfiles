{ pkgs, ... }:
let
  wezWrapped = pkgs.writeShellScriptBin "wezterm" ''
    # Clean wrapper: avoid overriding dynamic loader with host libs
    # Allow user to set WINIT/FRONTEND externally; provide safe defaults
    : "${WINIT_UNIX_BACKEND:=x11}"
    : "${WEZTERM_FRONTEND:=OpenGL}"
    export WINIT_UNIX_BACKEND WEZTERM_FRONTEND
    exec "${pkgs.wezterm}/bin/wezterm" "$@"
  '';
  xterm = pkgs.writeShellScriptBin "xterm" ''${wezWrapped}/bin/wezterm "$@"'';
  kgx = pkgs.writeShellScriptBin "kgx" ''${wezWrapped}/bin/wezterm "$@"'';
in {
  home.packages = [ wezWrapped xterm kgx ];
  xdg.configFile.wezterm.source = ../../wezterm;
}
