{ config, pkgs, ... }:

let
  pubkeySource = ../../hosts/common/users/arnaud/keys/id_arnaud-dell-precision7560.pub;
  pubkey = builtins.readFile pubkeySource;
in
{
  home.file.".ssh/id_arnaud-dell-precision7560.pub".source = pubkeySource;
  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
      # Default for all hosts
      "*" = {
        identityFile = [ "~/.ssh/id_arnaud-dell-precision7560" ];
      };
    };
  };
}
