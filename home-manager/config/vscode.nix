{ pkgs, ... }:
{
  programs.vscode.enable = true;
  home.file.".local/bin/code".text = ''#!/usr/bin/env sh
export LIBGL_DRIVERS_PATH="/usr/lib/dri:${pkgs.mesa.drivers}/lib/dri:''${LIBGL_DRIVERS_PATH:-}"
export __EGL_VENDOR_LIBRARY_DIRS="/usr/share/glvnd/egl_vendor.d:${pkgs.libglvnd}/share/glvnd/egl_vendor.d:''${__EGL_VENDOR_LIBRARY_DIRS:-}"
export LD_LIBRARY_PATH="$HOME/.nix-profile/lib:/usr/lib:''${LD_LIBRARY_PATH:-}"
exec "${pkgs.vscode}/bin/code" --disable-gpu --ozone-platform-hint=auto "$@"
'';
}
