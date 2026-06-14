{
  pkgs,
  config,
  globals,
  ...
}:

let
  pubkeySource = ../../../hosts/common/users/arnaud/keys/yubikey.pub;
  pubkey = builtins.readFile pubkeySource;
in
{
  home.file.".ssh/yubikey.pub".source = pubkeySource;
  home.file.".ssh/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/modules/home/ssh/config";
    force = true;
  };
  programs.ssh = {
    enableDefaultConfig = false;
    enable = true;
  };
}
