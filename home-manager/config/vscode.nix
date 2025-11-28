{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs; # FHS variant tends to work better with system GPU drivers on non-NixOS
  };
}
