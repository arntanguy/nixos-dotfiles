# Configures nautilus file manager with gvfs support
# for mounting drives and network shares.
#
# for google-drive support, connect using gnome-online-accounts-gtk
# NOTE: for nixos 25.11, google support is disabled by default in gvfs as there are security vulnerabilities
# in libsoup. see https://github.com/NixOS/nixpkgs/issues/438121
# It is forced to be enabled in flake.nix nixpkgs' overlay.

{
  pkgs,
  lib,
  config,
  globals,
  ...
}:
{
  options = {
    modules.nautilus.enable = lib.mkEnableOption "enables nautilus and gfvs integration";
  };

  config = lib.mkIf config.modules.nautilus.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      gnome-online-accounts
      gnome-online-accounts-gtk
    ];
    services.gnome.gnome-online-accounts.enable = true;
    services.gvfs.enable = true;
  };
}
