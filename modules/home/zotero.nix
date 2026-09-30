{
  pkgs,
  config,
  globals,
  ...
}:
{
  home.packages = [ pkgs.zotero ];
}
