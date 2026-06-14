{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    modules.yubikey.enable = lib.mkEnableOption "enables yubikey";
  };

  config = lib.mkIf config.modules.yubikey.enable {
    # For YubiKey
    services.pcscd.enable = true; # Smartcard mode (CCID)
    # Allow access to the YubiKey over USB
    services.udev.packages = [ pkgs.yubikey-personalization ];
    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      yubikey-personalization
      pinentry-rofi
    ];

    # Instructions on how to generate and store the keys on the YubiKey are available here:
    # https://rzetterberg.github.io/yubikey-gpg-nixos.html
    #
    # The key contains 3 private sub-keys: a signing key, an encryption key and an authentication key.
    # These private keys are non-extractable. A backup of the original certification master key is stored... somewhere hidden.
    #
    # To make it work on any machine, we use gpg-agent instead of ssh-agent.
    # Only the corresponding public key is needed. It is in hosts/common/users/arnaud/keys/yubikey.pub
    # Or on https://arntanguy.fr/yubikey.pub
    #
    # Instructions for import on another machine
    # - Install gnupg.
    # - Import the public key: gpg --import ./yubikey.pub
    # - Stop the ssh-agent, run gpg-agent
    # - (If for SSH) Ensure SSH_AUTH_SOCK points to the GPG agent: export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    # - Plug in YubiKey.
    # - Run gpg --card-status.
    #
    # Now:
    # gpg --list-secret-keys should show the private keys on the YubiKey as 'ssb>' entries
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # Pick a flavor: "curses" for terminal, "qt" or "gnome3" for GUI
      pinentryPackage = pkgs.pinentry-rofi;
    };
    # Disable ssh-agent in favor of gpg-agent
    # ssh-add keeps working as usual (as long as SSH_AUTH_SOCK is set to the gpg-agent, which the gnupg module does)
    programs.ssh.startAgent = false;
  };
}
