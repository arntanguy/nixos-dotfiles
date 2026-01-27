{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."swaylock/config".source = ./mocha.conf;
  home.file.".local/bin/nws.sh".source = ./nws.sh;
  home.file.".local/bin/niri-kill-focused.sh".source = ./niri-kill-focused.sh;

  home.packages = with pkgs; [
    sunsetr
  ];
}
