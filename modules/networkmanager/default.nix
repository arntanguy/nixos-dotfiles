{ pkgs, lib, config, globals, ... }:
{
  imports = [
    ./profiles/common.nix
  ];

  options = {
    modules.networkmanager.enable = 
      lib.mkEnableOption "enables networkmanager";
  };

  config = lib.mkIf config.modules.networkmanager.enable {
    networking = {
      hostName = globals.HostName;

      networkmanager = {
       enable = true;
      };
    };
    modules.networkmanager.profiles.common.enable = lib.mkDefault true;
  };
}
