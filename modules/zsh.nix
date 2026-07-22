{
  pkgs,
  lib,
  config,
  inputs,
  globals,
  ...
}:
{
  options = {
    modules.zsh.enable = lib.mkEnableOption "enables zsh configuration";
  };

  config = lib.mkIf config.modules.zsh.enable {
    # Install zsh
    users.users.${globals.UserName}.shell = pkgs.zsh;
    programs.zsh = {
      enable = true;
    };

    # Black magic to force nix develop to use zsh instead of bash
    # WARNING: shellHooks do not work well with this, they run in bash before starting zsh...
    environment.systemPackages = [ pkgs.any-nix-shell ];
    # Automatically initialize it for interactive Zsh sessions
    programs.zsh.interactiveShellInit = ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
    # End black magic
  };
}
