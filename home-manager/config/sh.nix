{
  pkgs,
  config,
  ...
}: let
  shellAliases = {
    "db" = "distrobox";
    "tree" = "eza --tree";
    "nv" = "nvim";

    "ll" = "ls";
    "éé" = "ls";
    "és" = "ls";
    "l" = "ls";

    ":q" = "exit";
    "q" = "exit";

    "gs" = "git status";
    "gb" = "git branch";
    "gch" = "git checkout";
    "gc" = "git commit";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
    "del" = "gio trash";

    "cfg" = "code /home/deck/pedro/dev/dotfiles-main";
    # Removidos aliases codegl/wezgl para simplificação; usar diretamente 'code' e 'wezterm'.

    "nxcg" = "nix-collect-garbage --delete-old";
    "hms" = "home-manager switch --flake /home/deck/pedro/dev/dotfiles-main#deck";
    "hmr" = "nix run nixpkgs#home-manager -- switch --flake /home/deck/pedro/dev/dotfiles-main#deck";
    "pjts" = "cd /home/deck";
    "forky" = "clear;neofetch";
  };
in {
  programs = {
    zsh = {
      inherit shellAliases;
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        SHELL=${pkgs.zsh}/bin/zsh
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP
        # fnm: use selected Node version and switch on cd
        if command -v fnm >/dev/null 2>&1; then
          eval "$(fnm env --use-on-cd)"
        fi
      '';
    };

    bash = {
      inherit shellAliases;
      enable = true;
      initExtra = ''
        SHELL=${pkgs.bash}/bin/bash
        # fnm: use selected Node version and switch on cd
        if command -v fnm >/dev/null 2>&1; then
          eval "$(fnm env --shell bash --use-on-cd)"
        fi
      '';
    };

    nushell = {
      inherit shellAliases;
      enable = true;
      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "\"  \"";
        PROMPT_INDICATOR_VI_NORMAL = "\"∙ \"";
        PROMPT_COMMAND = ''""'';
        PROMPT_COMMAND_RIGHT = ''""'';
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
        SHELL = ''"${pkgs.nushell}/bin/nu"'';
        EDITOR = config.home.sessionVariables.EDITOR;
        VISUAL = config.home.sessionVariables.VISUAL;
      };
      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";
          shell_integration = true;

          ls.clickable_links = true;
          rm.always_trash = true;

          table = {
            mode = "compact"; # compact thin rounded
            index_mode = "always"; # alway never auto
            header_on_separator = false;
          };

          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = "? ";
              type = {
                layout = "columnar"; # list, description
                columns = 4;
                col_padding = 2;
              };
              style = {
                text = "magenta";
                selected_text = "blue_reverse";
                description_text = "yellow";
              };
            }
          ];
        };
        completions = let
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
        in
          names:
            builtins.foldl'
            (prev: str: "${prev}\n${str}") ""
            (map (name: completion name) names);
      in ''
        $env.config = ${conf};
        ${completions ["cargo" "git" "nix" "npm"]}
      '';
    };

      # Home Manager may not have programs.fnm in this channel; we init via shell instead
  };
}
