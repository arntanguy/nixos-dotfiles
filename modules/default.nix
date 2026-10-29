{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./advertise-hostnames.nix
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
    ./fish.nix
    ./bash.nix
    ./audio.nix
    ./syncthing.nix
  ];

  modules.zsh.enable = lib.mkDefault false; # den: ignored
  modules.fish.enable = lib.mkDefault true; # den: moved
  modules.bash.enable = lib.mkDefault false; # den: ignored
  modules.laptop.enable = lib.mkDefault true;
  modules.ccache.enable = lib.mkDefault true;
  modules.yubikey.enable = lib.mkDefault true; # den: moved, improved
  # Disabling sops will make some other features such as some modules.networkmanager.profiles unavailable
  modules.sops.enable = lib.mkDefault true; # den: moved, improved
  modules.syncthing.enable = lib.mkDefault false; # den: moved, improved (reproducible ids, local hostnames)
  modules.networkmanager.enable = lib.mkDefault true; # den: done (but sops bug for multiple users)
  # Enable home-row mods by default
  modules.keyboard-mods.enable = lib.mkDefault true; # den: ignored for now, this does not work so well here
  modules.nautilus.enable = lib.mkDefault true; # den: moved
  modules.printing.enable = lib.mkDefault true; # den: moved
  modules.audio.enable = lib.mkDefault true; # den: moved
}
