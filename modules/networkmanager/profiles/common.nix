{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
{
  options = {
    modules.networkmanager.profiles.common = {
      enable = lib.mkEnableOption "enables networkmanager's profile <common>";
      useDHCP = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to use DHCP for the ethernet interface.";
      };
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
        "192.168.1.100" = [ "ur10_1" ];
        "192.168.1.200" = [ "ur10_2" ];
        "10.4.5.1" = [ "hrp4005c" ];
        "10.4.5.120" = [ "rhps1" ];
        "192.168.123.161" = [ "g1" ];
        "192.168.123.164" = [ "g1_jetson" ];
      };
    }
    (lib.mkIf (config.modules.sops.enable && config.modules.networkmanager.profiles.common.enable) (
      let
        ipSuffixStr = toString config.modules.networkmanager.profiles.common.ipSuffix;
        macAddr = config.modules.networkmanager.profiles.common.macAddress;
        useDHCP = config.modules.networkmanager.profiles.common.useDHCP;
      in
      {
        # For Unitree G1, we need to alias the interface name with a label
        # to differentiate the G1 ip from the others
        # use <interface-name>:g1 instead of <interface-name>
        systemd.services.add-g1-alias =
          let
            eth = "${globals.EthernetInterface}";
          in
          {
            description = "Add G1 alias IP to ${eth}";
            after = [ "network-addresses-${eth}.service" ];
            wants = [ "network-addresses-${eth}.service" ];
            partOf = [ "network-addresses-${eth}.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig.Type = "oneshot";
            serviceConfig.RemainAfterExit = true;
            script = ''
              /run/current-system/sw/bin/ip addr add 192.168.123.${ipSuffixStr}/24 dev ${eth} label ${eth}:g1
            '';
          };
        networking = {
          interfaces.${globals.EthernetInterface} = {
            inherit useDHCP;
            macAddress = lib.mkIf (macAddr != "") macAddr;
            ipv4.addresses = [
              {
                # UR
                address = "192.168.1.${ipSuffixStr}";
                prefixLength = 24;
              }
              {
                # hrp4005c / RHPS1
                address = "10.4.5.${ipSuffixStr}";
                prefixLength = 24;
              }
              # NOTE: for G1, see add-g1-alias service
            ];
          };
          # Do not let NetworkManager handle ethernet interface
          networkmanager.unmanaged = [
            globals.EthernetInterface
          ];

          networkmanager = {
            # Add default profiles to autoconnect
            # Note: secrets are available as files at runtime decripted by sops (in /run/secrets)
            # Set key-value pairs in secrets.yaml, and use the generated file as an environmentFiles entry for network manager. Secrets are then available as variables $SECRET_NAME in network profiles.
            ensureProfiles = {
              environmentFiles = [
                config.sops.secrets."data/networking/wifi/LIRMM".path
                config.sops.secrets."data/networking/wifi/EDUROAM".path
              ];
              profiles = {
                home_brest = {
                  connection = {
                    id = "home_brest";
                    type = "wifi";
                    autoconnect = true;
                    autoconnect-priority = 100; # Higher number wins
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "Livebox-6C80";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-psk";
                    psk = "$HOME_BREST_PASSWORD";
                  };
                };
                LIRMM = {
                  connection = {
                    id = "LIRMM";
                    type = "wifi";
                    autoconnect = true;
                    autoconnect-priority = 99; # Higher number wins
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "LIRMM";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-eap";
                  };
                  "802-1x" = {
                    eap = "peap";
                    identity = "$LIRMM_USER";
                    password = "$LIRMM_PASSWORD";
                    phase2-auth = "mschapv2";
                  };
                };
                eduroam = {
                  connection = {
                    id = "eduroam";
                    type = "wifi";
                    autoconnect = true;
                    autoconnect-priority = 98; # Higher number wins
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "eduroam";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-eap";
                  };
                  "802-1x" = {
                    eap = "peap";
                    identity = "$EDUROAM_USER";
                    password = "$EDUROAM_PASSWORD";
                    phase2-auth = "mschapv2";
                  };
                };
                arnaud-android-ap = {
                  connection = {
                    id = "arnaud-android-ap";
                    type = "wifi";
                    autoconnect = false;
                    autoconnect-priority = 10; # Higher number wins
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "arnaud";
                  };
                  wifi-security = {
                    key-mgmt = "wpa-psk";
                    psk = "$ARNAUD_ANDROID_AP_PASSWORD";
                  };
                  ipv4 = {
                    method = "auto";
                  };
                  ipv6 = {
                    method = "ignore";
                  };
                };
              };
            };
          };
        };
      }
    ))
  ];
}
