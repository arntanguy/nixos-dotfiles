{ pkgs, config, globals, ... }:

let
  pubkeySource = ../../../hosts/common/users/arnaud/keys/id_arnaud-dell-precision7560.pub;
  pubkey = builtins.readFile pubkeySource;
in
{
  home.file.".ssh/id_arnaud-dell-precision7560.pub".source = pubkeySource;
  home.file.".ssh/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/modules/home/ssh/config";
    force = true;
  };
  programs.ssh = {
    enable = true;
  };
}
