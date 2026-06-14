{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    modules.printing.enable = lib.mkEnableOption "enables printing";
  };

  config = lib.mkIf config.modules.printing.enable {
    # Enable CUPS and Avahi (for printer discovery):
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    # hardware.printers = {
    #   # ensureDefaultPrinter = "robcolor";
    #   ensurePrinters = [
    #     {
    #       deviceUri = "ipp://robcolor.lirmm.fr/ipp";
    #       location = "work";
    #       name = "robcolor";
    #       model = "everywhere";
    #     }
    #   ];
    # };
    environment.systemPackages = with pkgs; [
      wsdd # Web Service Discovery (WSD) host daemon for SMB/Samba
    ];
  };
}
