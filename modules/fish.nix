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
    modules.fish.enable = lib.mkEnableOption "enables fish by default";
  };

  config = lib.mkIf config.modules.fish.enable {
    # Install fish
    users.users.${globals.UserName}.shell = pkgs.fish;
    programs.fish = {
      enable = true;
    };
  };
}
