{ pkgs, lib, config, ... }:
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
      neovim
      pre-commit
      vscode
    ];
  };
}
