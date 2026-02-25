{ pkgs, lib, config, ... }:
{
  options = {
    modules.networkmanager.profiles.lirmm-pandas.enable = 
      lib.mkEnableOption "enables networkmanager's profile <lirmm-panda>";
  };

  config = lib.mkMerge [
    {
      networking.hosts = {
        "172.16.0.6" = [ "panda6" ];
        "172.16.1.7" = [ "panda7" ];
        "192.168.1.2" = [ "panda2" ];
      };
    }
    (lib.mkIf config.modules.networkmanager.profiles.lirmm-pandas.enable {
      networking = {
         interfaces.enp58s0u1u1 = {
            ipv4.addresses = [
              {
                address = "172.16.0.43";
                prefixLength = 24;
              }
              {
                address = "172.16.1.43";
                prefixLength = 24;
              }
              {
                address = "192.168.1.2";
                prefixLength = 24;
              }
            ];
          };
        };
  })
  ];
}
