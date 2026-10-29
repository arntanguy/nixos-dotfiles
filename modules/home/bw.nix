{ globals, pkgs, ... }:

{
  home.packages = with pkgs; [
    rbw
    rofi-rbw-wayland
  ];
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "${globals.Bwserver}";
      email = "${globals.Bwemail}";
      pinentry = pkgs.pinentry-rofi;
    };
  };
}
