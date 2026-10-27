{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ardour
    qjackctl
    qpwgraph # graphical patchbay
    pavucontrol
  ];
}
