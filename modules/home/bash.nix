{
  config,
  lib,
  pkgs,
  globals,
  ...
}:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      grep = "grep --color=auto";
      ls = "lsd";
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

    # Your environment variables
    initExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
      export GOPATH=$HOME/go
      export PATH="$PATH:$HOME/go/bin"
      eval "$(starship init bash)"
      eval "fastfetch"
    '';

  };

}
