let
  defaults = import ../globals-defaults.nix;
in
defaults
// {
  # this are the variables that you wanna change
  UserName = "panda";
  HostName = "bamboo";
  GitName = "Arnaud TANGUY";
  GitEmail = "arn.tanguy@gmail.com";
  Bwserver = "https://vault.arntanguy.fr";
  EthernetInterface = "enp58s0u1u1";
  terminal = "kitty";
  xkb = {
    layout = "fr";
    variant = "latin9";
    options = "grp:win_space_toggle,ctrl:nocaps";
  };

  enableWaybar = true;
  enableNiri = true;
  enableBash = true;
  enableFuzzel = true;
  enableTmux = true;
  enableNvim = true;
  enableGhostty = true;
  enableGit = true;
  enableScripts = true;
  enableNvidia = true;
  enableSsh = true;
  enableEmail = false;
  enableDavinciResolve = false;
}
