{
  config,
  pkgs,
  globals,
  ...
}:

{
  home.packages = with pkgs; [
    lazygit
  ];

  xdg.configFile."lazygit/config.yml".source = ./config.yml;
}
