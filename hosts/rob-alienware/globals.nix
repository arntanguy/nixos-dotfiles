let
  defaults = import ../globals-defaults.nix;
in
defaults // {
  # this are the variables that you wanna change
  UserName = "panda"; 
  HostName = "rob-alienware";
  GitName = "Arnaud TANGUY";
  GitEmail = "arn.tanguy@gmail.com";
  Bwserver = "https://vault.arntanguy.fr";
  EthernetInterface = "enp7s0";
  terminal = "kitty";
  xkb = {
    layout = "fr";
    variant = "latin9";
    options = "grp:win_space_toggle,ctrl:nocaps";
  };
}
