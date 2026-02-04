{ pkgs, lib, config, globals, ... }:
{
  options = {
    modules.sops.enable = 
      lib.mkEnableOption "enables sops secret management";
  };

  config = lib.mkIf config.modules.sops.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      age.keyFile = "/home/arnaud/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      # secrets are available as root in /run/secrets/<path> by default
      secrets = {
          "data/networking/wifi/LIRMM"= { };
          "ssh_keys/arnaud-dell-precision7560" = {
            path = "/home/${globals.UserName}/.ssh/id_arnaud-dell-precision7560";
            owner = globals.UserName;
          };
      };
    };

  };
}
