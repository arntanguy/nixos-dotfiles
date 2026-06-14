{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
{
  options = {
    modules.laptop.enable = lib.mkEnableOption "enables laptop-specific uses (power-management, etc)";
  };

  config = lib.mkIf config.modules.laptop.enable {
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };
}
