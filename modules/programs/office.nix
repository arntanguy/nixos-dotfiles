{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    modules.programs.office.enable = lib.mkEnableOption "enables office apps (pdf, libreoffice, etc)";
  };

  config = lib.mkIf config.modules.programs.office.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      evince # pdf reader
      zathura # pdf reader (minimalist)
      obsidian
      inkscape
    ];
  };
}
