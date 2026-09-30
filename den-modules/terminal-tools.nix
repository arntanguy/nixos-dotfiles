{
  den.aspects.terminal-tools = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        unzip
        bat # better cat
        btop
        curl
        fastfetch
        file
        # fzf
        jq
        lsd # better ls
        ripgrep
        starship
        tmux
        wget
        dua # disk usage analyzer
        # Nix/NixOS Tools
        nh
        imagemagick
        nmap
        acpi
      ];
    };
  };
}
