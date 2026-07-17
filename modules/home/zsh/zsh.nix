{
  pkgs,
  lib,
  globals,
  ...
}:
{
  home.file.".p10k.zsh".source = ./p10k.zsh;
  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      save = 10000;
      share = true;
    };

    antidote = {
      enable = true;
      plugins = [
        # Powerlevel10k theme (fancy, fast prompt)
        "romkatv/powerlevel10k"

        # Autosuggestions as you type
        "zsh-users/zsh-autosuggestions"
        # Syntax highlighting for commands
        "zsh-users/zsh-syntax-highlighting"

        # Fast directory switching (z command)
        # Use z <pattern> to go the the most used directory using <pattern>
        "rupa/z"

        # Fuzzy tab completion
        "Aloxaf/fzf-tab"
        # Fuzzy search through command history
        "joshskidmore/zsh-fzf-history-search"

        # Oh-My-Zsh plugins
        # Git aliases and helpers
        "ohmyzsh/ohmyzsh path:plugins/git"
        # Colored man pages
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
        # Quickly prepend sudo to commands
        # Pres <Esc><Esc> twice to prepend sudo
        # "ohmyzsh/ohmyzsh path:plugins/sudo"
        # History management
        "ohmyzsh/ohmyzsh path:plugins/history"
        # Reminds you to use defined aliases
        "MichaelAquilina/zsh-you-should-use"
      ];
    };
    initContent = ''
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      setopt NO_BEEP
    '';
    shellAliases = {
      grep = "grep --color=auto";
      ls = "lsd --hyperlink=auto";
      ll = "ls -l";
      la = "ls -lAtr";
      cat = "bat";
      ta = "tmux a";
      gh_queue_pr = "gh pr comment -b '@mergifyio queue'";
      gh_qpr = "gh_queue_pr";
      gh_co = "gh checkout";
    }
    // lib.optionalAttrs globals.enableBitwarden {
      token_cachix = "rbw get token_mc-rtc-nix-cachix";
      token_attic_aist = "rbw get token_attic";
      token_copy_rofi = "rofi-rbw -a copy --clipboarder wl-copy -t password -r 'Copy pwd: '";
      token_print_rofi = "rofi-rbw -a print -t password -r 'Print pwd: '";
    };

  };
}
