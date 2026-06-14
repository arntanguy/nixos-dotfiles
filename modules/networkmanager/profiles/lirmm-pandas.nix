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
      ipSuffix = lib.mkOption {
        type = lib.types.int;
        default = 43;
        description = "Last octet of the local IP address for panda profile.";
        example = 99;
      };
      macAddress = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Custom MAC address for panda profile (leave empty for default).";
        example = "00:11:22:33:44:55";
      };
    };
  };

  config = lib.mkMerge [
    {
      networking.hosts = {
        "172.16.0.6" = [ "panda6" ];
        "172.16.1.7" = [ "panda7" ];
        "192.168.1.2" = [ "panda2" ];
        "172.16.0.1" = [ "panda_ganesh" ];
      };
    }
    (lib.mkIf config.modules.networkmanager.profiles.lirmm-pandas.enable (
      let
        ipSuffixStr = toString config.modules.networkmanager.profiles.lirmm-pandas.ipSuffix;
        macAddr = config.modules.networkmanager.profiles.lirmm-pandas.macAddress;
      in
      {
        networking = {
          interfaces.${globals.EthernetInterface} = {
            mtu = 1400; # or even 1280 reduce latency
            # Set custom MAC address if specified
            macAddress = lib.mkIf (macAddr != "") macAddr;
            useDHCP = false;
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
      }
    ))
  ];
}
