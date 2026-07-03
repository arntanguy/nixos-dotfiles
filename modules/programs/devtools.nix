{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    modules.programs.devtools.enable = lib.mkEnableOption "enables devtools";
  };

  config = lib.mkIf config.modules.programs.devtools.enable {
    environment.systemPackages = with pkgs; [
      # Development Tools
      cmakeCurses
      gcc
      ccache
      gh # github cli
      git
      gnumake
      go
      gopls
      lazydocker
      musl
      pre-commit
      prek
      vscode
      # XXX: we could also use its nixosModule, but not sure how to include it here
      # inputs.nvim-wrapper.packages."${pkgs.system}".neovim
      devpod
      docker
      docker-compose
      nixfmt
      nurl # Generate Nix Fetcher calls from repository URLs
      cachix
      attic-client
      cloudsmith-cli
      nix-tree # Interactive visualization of dependency tree
      graphviz
      nix-visualize # generate graphs of dependency trees
    ];
  };
}
