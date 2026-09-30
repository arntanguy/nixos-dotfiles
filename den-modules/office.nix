{
  den.aspects.office = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        libreoffice
        evince # pdf reader
        zathura # pdf reader (minimalist)
        obsidian
        inkscape
      ];
    };
  };
}
