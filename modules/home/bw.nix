{ globals, ... }:

{
  services.bitwarden-directory-connector-cli.domain = globals.Bwserver;
  services.bitwarden-directory-connector-cli.enable = true;

  home.packages = with pkgs; [
    bitwarden-cli
  ];
}
