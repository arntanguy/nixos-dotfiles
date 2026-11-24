{ config, lib, ... }:
{
  options = {
    modules.nvidia.enable = lib.mkEnableOption "enables nvidia configuration (no offloading)";
  };

  config = lib.mkIf config.modules.nvidia.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      open = true; # RTX A4000 is Ampere (post-Turing), so open kernel modules apply
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload.enable = false;
        offload.enableOffloadCmd = false;
        # Keep bus IDs only if needed by your setup, or remove offload block
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
