{ pkgs, lib, config, ... }:
{
  options = {
    modules.yubikey.enable = 
      lib.mkEnableOption "enables yubikey";
  };

  config = lib.mkIf config.modules.yubikey.enable {
    # For YubiKey
    services.pcscd.enable = true; # Smartcard mode (CCID)
    services.udev.packages = [ pkgs.yubikey-personalization ];
    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
    ];
  };
}
