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
    modules.bash.enable = lib.mkEnableOption "enables bash by default";
  };

  config = lib.mkIf config.modules.bash.enable {
    # Install bash
    users.users.${globals.UserName}.shell = pkgs.bash;
    programs.bash = {
      enable = true;
    };
  };
}
