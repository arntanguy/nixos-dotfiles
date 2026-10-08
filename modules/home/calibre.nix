{
  pkgs,
  config,
  globals,
  ...
}:
{
  programs.calibre = {
    enable = true;
    plugins = [ ];
  };
}
