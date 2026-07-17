{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./laptop.nix
    ./yubikey.nix
    ./sops.nix
    ./nautilus.nix
    ./printing.nix
    ./networkmanager
    ./keyboard
    ./programs
    ./ccache.nix
    ./zsh.nix
  ];

  modules.zsh.enable = lib.mkDefault true;
  modules.laptop.enable = lib.mkDefault true;
  modules.ccache.enable = lib.mkDefault true;
  modules.yubikey.enable = lib.mkDefault true;
  # Disabling sops will make some other features such as some modules.networkmanager.profiles unavailable
  modules.sops.enable = lib.mkDefault true;
  modules.networkmanager.enable = lib.mkDefault true;
  # Enable home-row mods by default
  modules.keyboard-mods.enable = lib.mkDefault true;
  modules.nautilus.enable = lib.mkDefault true;
  modules.printing.enable = lib.mkDefault true;
}
