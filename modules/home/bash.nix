{
  pkgs,
  lib,
  globals,
  ...
}:

let
  # Explicitly force fd to load your global ignore file
  fdBase = "fd --ignore-file ~/.config/fd/ignore";
in
{
  # Configure ~/.config/fd/ignore using pure gitignore syntax
  home.file.".config/fd/ignore".text = ''
    # Ignore all hidden files and folders
    .*
    .**/*

    # Un-ignore .github and all of its contents
    !.github/
    !.github/**
  '';

  home.packages = with pkgs; [
    fd
    lsd
    bat
    rbw
    wl-clipboard
  ];

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  # use z <name> to jump to most likely directory
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };

  # Use
  # Alt-C : fuzzy jump to folder
  # Ctrl-T : fuzzy search file
  # Ctrl-R : fuzzy command history with atui
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    historyWidget.command = ""; # Yield Ctrl+R to Atuin
  };

  programs.bash = {
    enable = true;

    historySize = 10000;
    historyFileSize = 10000;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    initExtra = ''
      # Disable beep
      set +o bllink 2>/dev/null || true
      bind 'set bell-style none'

      # Colored man pages
      export LESS_TERMCAP_mb=$'\e[1;31m'
      export LESS_TERMCAP_md=$'\e[1;36m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;32m'
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
