{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./devtools.nix
    ./office.nix
    ./communication.nix
    ./terminal-tools.nix
  ];

  modules.programs.devtools.enable = lib.mkDefault false; # den
  modules.programs.office.enable = lib.mkDefault false;
  modules.programs.communication.enable = lib.mkDefault false;
  modules.programs.terminal-tools.enable = lib.mkDefault false;
}
