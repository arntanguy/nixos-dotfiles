{ pkgs, lib, config, globals, ... }:
{
  options = {
    modules.sops.enable = 
      lib.mkEnableOption "enables sops secret management";
  };

  config = lib.mkIf config.modules.sops.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      age.keyFile = "/home/arnaud/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      # secrets are available as root in /run/secrets/<path> by default
      secrets = {
          "data/networking/wifi/LIRMM"= { };
          "data/networking/wifi/EDUROAM"= { };
          # XXX: Needed to enable nix build to fetch private repositories
          "data/github/NIX_GH_REPO_TOKEN"= { };
      };
    };

    # Create a /etc/nix/netrc file with a github token to access private repositories
    # from within nix sandbox
    sops.templates.netrc = {
      content = ''
        machine github.com
            password ${config.sops.placeholder."data/github/NIX_GH_REPO_TOKEN"}
      '';
      mode = "0400";
      path = "/etc/nix/netrc";
    };
    # allow sandboxed builds access to private repositories
    nix.settings.netrc-file = "/etc/nix/netrc";

  };
}
