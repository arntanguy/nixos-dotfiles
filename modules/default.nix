{ pkgs, lib, config, ... }:
{
  imports = [
    ./yubikey.nix
    ./sops.nix
    ./networkmanager
    ./keyboard
    ./programs
  ];

  modules.yubikey.enable = lib.mkDefault true;
  # Disabling sops will make some other features such as some modules.networkmanager.profiles unavailable
  modules.sops.enable = lib.mkDefault true;
  modules.networkmanager.enable = lib.mkDefault true;
  # Enable home-row mods by default
  modules.keyboard-mods.enable = lib.mkDefault true;
}
