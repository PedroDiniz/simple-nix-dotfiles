{ pkgs, ... }:
{
  programs.vscode.enable = true;
  # Minimal wrapper: rely on Nix RPATH; don't inject host /usr/lib
  home.file.".local/bin/code".text = ''#!/usr/bin/env sh
exec "${pkgs.vscode}/bin/code" --disable-gpu --use-gl=swiftshader --ozone-platform-hint=auto "$@"
'';
  home.file.".local/bin/code".executable = true;
}
