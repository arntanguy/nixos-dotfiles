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
  };
}
