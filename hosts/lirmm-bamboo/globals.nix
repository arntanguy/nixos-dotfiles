let
  defaults = import ../globals-defaults.nix;
in
defaults // {
  # this are the variables that you wanna change
  UserName = "panda"; 
  HostName = "bamboo";
  GitName = "Arnaud TANGUY";
  GitEmail = "arn.tanguy@gmail.com";
  Bwserver = "https://vault.arntanguy.fr";
  EthernetInterface = "enp58s0u1u1";
  xkb = {
    layout = "fr";
    options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
  };
}
