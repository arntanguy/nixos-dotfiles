{ pkgs, lib, config, globals, ... }:
{
  options = {
    modules.networkmanager.profiles.lirmm-pandas = {
      enable = 
        lib.mkEnableOption "enables networkmanager's profile <lirmm-panda>";
      ipSuffix = lib.mkOption {
        type = lib.types.int;
        default = 43;
        description = "Last octet of the local IP address for panda profile.";
        example = 99;
      };
    };
  };

  config = lib.mkMerge [
    {
      networking.hosts = {
        "172.16.0.6" = [ "panda6" ];
        "172.16.1.7" = [ "panda7" ];
        "192.168.1.2" = [ "panda2" ];
      };
    }
    (lib.mkIf config.modules.networkmanager.profiles.lirmm-pandas.enable
      (let
        ipSuffixStr = toString config.modules.networkmanager.profiles.lirmm-pandas.ipSuffix;
      in {
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
            ];
          };
        };
      })
    )
  ];
}
