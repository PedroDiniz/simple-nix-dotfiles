{ pkgs, ... }:
let
  wezWrapped = pkgs.writeShellScriptBin "wezterm" ''
    # Prefer host GL/EGL drivers; avoid broad LD_LIBRARY_PATH to reduce conflicts
    export LIBGL_DRIVERS_PATH="/usr/lib/dri:${pkgs.mesa.drivers}/lib/dri:''${LIBGL_DRIVERS_PATH:-}"
    export __EGL_VENDOR_LIBRARY_DIRS="/usr/share/glvnd/egl_vendor.d:${pkgs.libglvnd}/share/glvnd/egl_vendor.d:''${__EGL_VENDOR_LIBRARY_DIRS:-}"
    # Ensure the dynamic linker can find libEGL.so from Nix profile or host
    export LD_LIBRARY_PATH="$HOME/.nix-profile/lib:/usr/lib:''${LD_LIBRARY_PATH:-}"
    # Force X11 backend as a safe default on SteamOS if Wayland segfaults
    export WINIT_UNIX_BACKEND="x11"
    export WEZTERM_FRONTEND="OpenGL"
    exec "${pkgs.wezterm}/bin/wezterm" "$@"
  '';
  xterm = pkgs.writeShellScriptBin "xterm" ''${wezWrapped}/bin/wezterm "$@"'';
  kgx = pkgs.writeShellScriptBin "kgx" ''${wezWrapped}/bin/wezterm "$@"'';
in {
  home.packages = [ wezWrapped xterm kgx ];
  xdg.configFile.wezterm.source = ../../wezterm;
  xdg.desktopEntries."org.wezfurlong.wezterm" = {
    name = "WezTerm";
    exec = "wezterm";
    icon = "org.wezfurlong.wezterm";
    terminal = false;
    categories = [ "TerminalEmulator" ];
  };
}
