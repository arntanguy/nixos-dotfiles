##
# NVIDIA configuration
# This module installs an nv-run script to run any app that honours the __NV_PRIME_RENDER_OFFLOAD variables using the nvidia card
# It wraps applications that require nvidia GPU to run to use these variables automatically. This works with the desktop entry as well as
# it overrides the default program executable
{ pkgs, config, lib, osConfig, ... }:

let
  # 1. System-level detection
  # Check multiple potential locations for Nvidia activation
  isNvidiaSystem = osConfig.hardware.nvidia.modesetting.enable or false;

  # 2. Define the GPU Environment Variables
  nvidiaEnv = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_SET_GROUP = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  # 3. Create 'nv-run' as a standalone package
  # If no Nvidia is found, it just acts as a passthrough ('exec $@')
  nv-run = pkgs.writeShellScriptBin "nv-run" (
    if isNvidiaSystem then ''
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "export ${n}=${v}") nvidiaEnv)}
      exec "$@"
    '' else ''
      exec "$@"
    ''
  );

  # 4. Conditional wrapper function for specific apps
  maybeWrapPrime = pkg: 
    if isNvidiaSystem 
    then (pkgs.symlinkJoin {
      name = "${pkg.pname or pkg.name}-wrapped-prime";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${pkg.pname or pkg.name} \
          ${lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "--set ${name} ${value}") nvidiaEnv)}
      '';
    })
    else pkg;

in {
  home.packages = [
    # Install the standalone utility
    nv-run
    
    # Install the wrapped versions of your apps requiring nvidia card
    (maybeWrapPrime pkgs.davinci-resolve)
    (maybeWrapPrime pkgs.blender)
    (maybeWrapPrime pkgs.darktable)
    (maybeWrapPrime pkgs.vlc)
    (maybeWrapPrime pkgs.totem) # mostly for totem-video-thumbnailer for nautilus
  ];
}
