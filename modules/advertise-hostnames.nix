{
  ...
}:
{
  config = {
        # 1. Enable Avahi (mDNS daemon)
        services.avahi = {
          enable = true;
          nssmdns4 = true; # Allows resolving .local names for IPv4
          nssmdns6 = true; # Allows resolving .local names for IPv6

          publish = {
            enable = true;
            addresses = true;   # Publishes IPv4 and IPv6 addresses (<hostname>.local)
            domain = true;      # Publishes local domain name
            workstation = true; # Publishes workstation service on LAN
          };
        };

        # 2. Ensure UDP port 5353 (mDNS) is permitted in the firewall
        # Note: services.avahi.enable automatically opens port 5353, but you can explicitly ensure it:
        networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
