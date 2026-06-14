{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    modules.networkmanager.profiles.common.enable =
      lib.mkEnableOption "enables networkmanager's profile <common>";
  };

  config = lib.mkMerge [
    {
      networking.hosts = {
        "192.168.1.100" = [ "ur10_1" ];
        "192.168.1.200" = [ "ur10_2" ];
        "10.4.5.1" = [ "hrp4005c" ];
        "10.4.5.120" = [ "rhps1" ];
      };
    }
    (lib.mkIf (config.modules.sops.enable && config.modules.networkmanager.profiles.common.enable) {
      networking = {
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
              LIRMM = {
                connection = {
                  id = "LIRMM";
                  type = "wifi";
                  autoconnect = true;
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
              robots-ethernet = {
                connection = {
                  id = "Robots Ethernet";
                  type = "ethernet";
                  autoconnect = false;
                };
                ipv4 = {
                  method = "manual";
                  address1 = "10.4.5.42/24"; # for hrp4005c and rhps1
                  address2 = "172.16.0.42/16"; # for panda6 and panda7
                  address3 = "192.168.1.42/24"; # for panda2
                };
                ipv6 = {
                  method = "ignore";
                };
              };
            };
          };
        };
      };
    })
  ];
}
