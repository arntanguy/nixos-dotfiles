{ pkgs, lib, config, ... }:
{
  options = {
    modules.programs.communication.enable = 
      lib.mkEnableOption "enables communication apps (matrix, slack, etc)";
  };

  config = lib.mkIf config.modules.programs.communication.enable {
    environment.systemPackages = with pkgs; [
      element-desktop # matrix
      slack
      zoom-us
      discord
    ];
  };
}
