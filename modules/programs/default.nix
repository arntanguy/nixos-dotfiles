{ pkgs, lib, config, ... }:
{
  imports = [
    ./devtools.nix
  ];

  modules.programs.devtools.enable = lib.mkDefault true;
}
