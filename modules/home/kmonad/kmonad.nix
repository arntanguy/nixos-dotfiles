{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    kmonad
  ];
  # xdg.configFile."kmonad/config.kbd".source = ./config.kbd;
}
