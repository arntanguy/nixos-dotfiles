{ config, lib, ... }:
let
  isNvidia = config.hardware.nvidia.modesetting.enable or false;
  nvidiaOffloadVars = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_SET_GROUP = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };
in
{
  options = {
    modules.nvidia-offload.enable = lib.mkEnableOption "enables nvidia configuration (offloading)";
  };

  config = lib.mkIf config.modules.nvidia-offload.enable {
    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    environment.sessionVariables = lib.mkIf isNvidia (
      builtins.trace "using nvidia offloading environment variables" nvidiaOffloadVars
    );
  };
}
