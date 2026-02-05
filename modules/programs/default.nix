{ pkgs, lib, config, ... }:
{
  imports = [
    ./devtools.nix
    ./office.nix
    ./communication.nix
  ];

  modules.programs.devtools.enable = lib.mkDefault true;
  modules.programs.office.enable = lib.mkDefault true;
  modules.programs.communication.enable = lib.mkDefault true;
}
