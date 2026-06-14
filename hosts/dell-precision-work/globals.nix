let
  defaults = import ../globals-defaults.nix;
in
defaults
// {
  # this are the variables that you wanna change xd
  UserName = "arnaud";
  HostName = "arnaud";
  GitName = "Arnaud TANGUY";
  GitEmail = "arn.tanguy@gmail.com";
  Bwserver = "https://vault.arntanguy.fr";
  # When plugged to the ethernet port
  EthernetInterface = "enp0s31f6";
  # when plugged over usb-c
  # EthernetInterface = "enp78s0";
  xkb = {
    layout = "us";
    variant = "";
    options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
  };
}
