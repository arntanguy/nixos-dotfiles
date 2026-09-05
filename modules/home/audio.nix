{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ardour
    reaper
    qjackctl
    qpwgraph # graphical patchbay
    pavucontrol
  ];
}
