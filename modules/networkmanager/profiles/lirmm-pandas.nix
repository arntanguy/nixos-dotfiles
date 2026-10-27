{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
{
  options = {
    modules.networkmanager.profiles.lirmm-pandas = {
      enable = lib.mkEnableOption "enables networkmanager's profile <lirmm-panda>";
    };
  };

  config = lib.mkMerge [
    {
      networking.hosts = {
        "172.16.0.6" = [ "panda6" ];
        "172.16.1.7" = [ "panda7" ];
        "192.168.1.2" = [ "panda2" ];
        "172.16.0.1" = [ "panda_ganesh" ];
        "192.168.42.32" = [ "ender3.ethernet" ];
        "172.16.0.103" = [ "ar-xmg-rob.local" ];
      };
      networking.networkmanager.enable = true;

      # Do not let NetworkManager handle ethernet interface
      networking.networkmanager.unmanaged = [
        globals.EthernetInterface
      ];
    }
    (lib.mkIf config.modules.networkmanager.profiles.lirmm-pandas.enable (
      let
        ipSuffixStr = toString config.modules.networkmanager.profiles.common.ipSuffix;
      in
      {
        networking = {
          interfaces.${globals.EthernetInterface} = {
            ipv4.addresses = [
              {
                address = "172.16.0.${ipSuffixStr}";
                prefixLength = 24;
              }
              {
                address = "172.16.1.${ipSuffixStr}";
                prefixLength = 24;
              }
              {
                address = "192.168.1.${ipSuffixStr}";
                prefixLength = 24;
              }
              {
                # ender3 ethernet
                address = "192.168.42.${ipSuffixStr}";
                prefixLength = 24;
              }
            ];
          };
        };
      }
    ))
  ];
}
