{ pkgs, lib, config, inputs, ... }:
{
  options = {
    modules.programs.devtools.enable = 
      lib.mkEnableOption "enables devtools";
  };

  config = lib.mkIf config.modules.programs.devtools.enable {
    environment.systemPackages = with pkgs; [
      # Development Tools
      cmakeCurses
      gcc
      gh # github cli
      git
      gnumake
      go
      gopls
      lazydocker
      lazygit
      musl
      pre-commit
      prek
      vscode
      inputs.nixCats.packages."${pkgs.system}".nixCats
      devpod
      docker
      docker-compose
      nixfmt-rfc-style
      nurl # Generate Nix Fetcher calls from repository URLs
      cachix
    ];
  };
}
